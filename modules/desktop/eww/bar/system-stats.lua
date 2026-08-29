#!/usr/bin/env luajit
-- system-stats: emit {cpu, ram, net, sound} as JSON.
--
-- Single-threaded LuaJIT port of the original Python script. Instead of
-- OS threads, a single supervisor loop schedules the periodic cpu/ram and
-- sound refreshes and polls an inotifywait child for link-state changes.
local cjson = require("cjson")
local posix = require("posix")
local unistd = require("posix.unistd")
local gettimeofday = require("posix.sys.time").gettimeofday
local poll = require("posix.poll").poll

local NULL = cjson.null

local function nonnull(v)
  if v == nil then
    return NULL
  end
  return v
end

-- Throughput deltas between cpu/ram refreshes
local net_last_time = nil
local net_last_bytes = {}

-- ------------------------------------------------ time
local function mono_sec()
  local g = gettimeofday()
  return g.tv_sec + g.tv_usec / 1e6
end

-- ------------------------------------------------ process helpers
local function sh(cmd)
  local h = io.popen(cmd)
  if not h then
    return nil
  end
  local out = h:read("*a")
  h:close()
  return out
end

-- ------------------------------------------------ formatting
local function format_rate(bytes_per_sec)
  if bytes_per_sec == nil or bytes_per_sec < 0 then
    return "0B"
  end
  local units = { "B", "K", "M", "G", "T" }
  local val = bytes_per_sec
  local unit_idx = 1
  while val >= 1024 and unit_idx < #units do
    val = val / 1024.0
    unit_idx = unit_idx + 1
  end
  local unit = units[unit_idx]
  if val >= 100 or unit == "B" then
    return string.format("%d%s", math.floor(val + 0.5), unit)
  end
  return string.format("%.1f%s", val, unit)
end

local function format_bytes(kib)
  if kib == nil or kib < 0 then
    return "0B"
  end
  local units = { "K", "M", "G", "T" }
  local val = kib
  local unit_idx = 1
  while val >= 1024 and unit_idx < #units do
    val = val / 1024.0
    unit_idx = unit_idx + 1
  end
  local unit = units[unit_idx]
  if val >= 100 or unit == "K" then
    return string.format("%d%s", math.floor(val + 0.5), unit)
  end
  return string.format("%.1f%s", val, unit)
end

-- ------------------------------------------------ /proc readers
local function read_cpu_times()
  local times = {}
  local f = io.open("/proc/stat")
  if not f then
    return times
  end
  for line in f:lines() do
    if not line:match("^cpu") then
      break
    end
    local parts = {}
    for w in line:gmatch("%S+") do
      parts[#parts + 1] = w
    end
    local label = parts[1]
    local total, idle = 0, 0
    for j = 2, #parts do
      local v = tonumber(parts[j]) or 0
      total = total + v
      if j == 4 or j == 5 then
        idle = idle + v
      end
    end
    times[label] = { idle = idle, total = total }
  end
  f:close()
  return times
end

local function get_cpu_freq_mhz()
  local count, sum, ok = 0, 0, false
  local f = io.open("/proc/cpuinfo")
  if not f then
    return nil
  end
  for line in f:lines() do
    local low = line:lower()
    if low:find("^cpu mhz") then
      local val = line:match(":%s*([%d%.]+)")
      if val then
        sum = sum + tonumber(val)
        count = count + 1
        ok = true
      end
    end
  end
  f:close()
  if not ok then
    return nil
  end
  return math.floor(sum / count + 0.5)
end

local function get_load_avg()
  local f = io.open("/proc/loadavg")
  if not f then
    return nil
  end
  local line = f:read("*l")
  f:close()
  if not line then
    return nil
  end
  local a, b, c = line:match("^([%d%.]+)%s+([%d%.]+)%s+([%d%.]+)")
  if not a then
    return nil
  end
  return { tonumber(a), tonumber(b), tonumber(c) }
end

local function get_ram_speed_mhz()
  local out = sh("dmidecode -t 17 2>/dev/null")
  if not out then
    return nil
  end
  local speeds = {}
  for line in out:gmatch("[^\n]+") do
    local s = line:match("^%s*Configured Memory Speed:%s*(.-)%s*$")
    if s then
      local low = s:lower()
      if low ~= "unknown" and low ~= "no module installed" then
        local num = s:match("^(%d+)")
        if num then
          speeds[#speeds + 1] = tonumber(num)
        end
      end
    end
  end
  if #speeds == 0 then
    for line in out:gmatch("[^\n]+") do
      local s = line:match("^%s*Speed:%s*(.-)%s*$")
      if s then
        local low = s:lower()
        if low ~= "unknown" and low ~= "no module installed" then
          local num = s:match("^(%d+)")
          if num then
            speeds[#speeds + 1] = tonumber(num)
          end
        end
      end
    end
  end
  if #speeds == 0 then
    return nil
  end
  local mx = speeds[1]
  for j = 2, #speeds do
    if speeds[j] > mx then
      mx = speeds[j]
    end
  end
  return mx
end

-- ------------------------------------------------ network helpers
local function get_all_default_ifaces()
  local out = sh("ip -o route show default 2>/dev/null")
  if not out then
    return {}
  end
  local ifaces = {}
  local seen = {}
  for line in out:gmatch("[^\n]+") do
    local iface = line:match("dev (%S+)")
    if iface and not seen[iface] then
      seen[iface] = true
      ifaces[#ifaces + 1] = iface
    end
  end
  return ifaces
end

local function get_iface_ip(iface)
  if not iface or iface == "" then
    return nil
  end
  local out = sh("ip -o -4 addr show dev " .. iface .. " 2>/dev/null")
  if not out then
    return nil
  end
  local ip = out:match("inet (%d+%.%d+%.%d+%.%d+)")
  return ip
end

local function get_operstate(iface)
  local f = io.open("/sys/class/net/" .. iface .. "/operstate")
  if not f then
    return "down"
  end
  local s = f:read("*l")
  f:close()
  return (s and s:match("^%s*(.-)%s*$")) or "down"
end

local function get_iface_type(iface)
  if posix.stat("/sys/class/net/" .. iface .. "/wireless") then
    return "wifi"
  end
  local st = posix.stat("/sys/class/net/" .. iface .. "/bridge")
  if st and st.type == "directory" then
    return "bridge"
  end
  if posix.stat("/sys/class/net/" .. iface .. "/tun_flags") then
    return "tun"
  end
  return "ethernet"
end

local function get_speed_mbps(iface, iftype)
  if iftype == "ethernet" then
    local f = io.open("/sys/class/net/" .. iface .. "/speed")
    if f then
      local s = f:read("*l")
      f:close()
      local num = s and tonumber(s:match("^%s*(-?%d+)"))
      if num and num >= 0 then
        return num
      end
    end
    return nil
  end
  if iftype == "wifi" then
    local out = sh("iw dev " .. iface .. " link 2>/dev/null")
    if not out then
      return nil
    end
    for line in out:gmatch("[^\n]+") do
      local l = line:match("^%s*tx bitrate:%s*(.-)%s*$")
      if l then
        local num = tonumber(l:match("^([%d%.]+)"))
        if num then
          return math.floor(num + 0.5)
        end
      end
    end
  end
  return nil
end

local function get_iface_io_bytes(iface)
  if not iface or iface == "" then
    return nil, nil
  end
  local f = io.open("/proc/net/dev")
  if not f then
    return nil, nil
  end
  local rx, tx
  for line in f:lines() do
    local colon = line:find(":")
    if colon then
      local dev = line:sub(1, colon - 1):match("^%s*(.-)%s*$")
      if dev == iface then
        local fields = {}
        for w in line:sub(colon + 1):gmatch("%S+") do
          fields[#fields + 1] = w
        end
        rx = tonumber(fields[1]) or nil
        tx = tonumber(fields[9]) or nil
        break
      end
    end
  end
  f:close()
  return rx, tx
end

-- ------------------------------------------------ tooltips
local function build_cpu_tooltip(overall_pct, per_core_list, freq_mhz, load_avg)
  local lines = { string.format("CPU: %d%%", overall_pct) }
  if freq_mhz ~= nil then
    lines[#lines + 1] = string.format("Freq: %d MHz", freq_mhz)
  end
  if load_avg ~= nil then
    lines[#lines + 1] = string.format(
      "Load: %.2f %.2f %.2f",
      load_avg[1],
      load_avg[2],
      load_avg[3]
    )
  end
  for i, pct in ipairs(per_core_list) do
    lines[#lines + 1] = string.format("Core %d: %d%%", i - 1, pct)
  end
  return table.concat(lines, "\n")
end

local function build_ram_tooltip(ram_pct, used, total, available, swap_pct, swap_used, swap_total, speed_mhz)
  local lines = { string.format("RAM: %d%% (%s / %s)", ram_pct, used, total) }
  lines[#lines + 1] = "Available: " .. available
  lines[#lines + 1] = string.format("Swap: %d%% (%s / %s)", swap_pct, swap_used, swap_total)
  if speed_mhz ~= nil then
    lines[#lines + 1] = string.format("Speed: %d MHz", speed_mhz)
  else
    lines[#lines + 1] = "Speed: unknown"
  end
  return table.concat(lines, "\n")
end

local function build_sound_tooltip(percent, mute, sink)
  local vol = tostring(percent) .. "%"
  local lines = {}
  if mute then
    lines[#lines + 1] = string.format("Muted (%s)", vol)
  else
    lines[#lines + 1] = "Volume: " .. vol
  end
  if sink then
    lines[#lines + 1] = "Sink: " .. sink
  end
  return table.concat(lines, "\n")
end

-- ------------------------------------------------ state collectors
-- get_all_default_ifaces (`ip route`), get_iface_ip (`ip addr`), and the
-- wifi branch of get_speed_mbps (`iw dev link`) each spawn a subprocess.
-- Those three rarely change second-to-second, so they're only re-probed
-- every NET_SLOW_REFRESH_INTERVAL instead of on every check_net_status()
-- call. operstate, iface type, ethernet speed, and rx/tx byte counters are
-- all plain sysfs/proc reads with no subprocess involved, so they stay
-- live on every call regardless -- rx/tx throughput in particular needs
-- to stay frequent to be useful.
local NET_SLOW_REFRESH_INTERVAL = 15.0
local net_slow_ifaces = nil
local net_slow_ip = {}
local net_slow_wifi_speed = {}
local net_slow_expires_at = 0

local function refresh_net_slow_cache(now)
  net_slow_ifaces = get_all_default_ifaces()
  local ip_cache, wifi_speed_cache = {}, {}
  for _, iface in ipairs(net_slow_ifaces) do
    ip_cache[iface] = get_iface_ip(iface)
    if get_iface_type(iface) == "wifi" then
      wifi_speed_cache[iface] = get_speed_mbps(iface, "wifi")
    end
  end
  net_slow_ip = ip_cache
  net_slow_wifi_speed = wifi_speed_cache
  net_slow_expires_at = now + NET_SLOW_REFRESH_INTERVAL
end

-- Pass force=true to bypass the timer and re-probe immediately (used for
-- the initial call and whenever inotify reports an actual link change).
local function check_net_status(force)
  local now = mono_sec()
  if force or net_slow_ifaces == nil or now >= net_slow_expires_at then
    refresh_net_slow_cache(now)
  end

  local ifaces = net_slow_ifaces

  if #ifaces == 0 then
    return { status = "down", tooltip = "Network Offline", routes = {} }
  end

  local routes = {}
  local any_up = false
  local any_limited = false

  for _, iface in ipairs(ifaces) do
    local oper = get_operstate(iface)
    if oper == "up" then
      any_up = true
    elseif oper == "dormant" then
      any_limited = true
    end

    local iftype = get_iface_type(iface)
    local ip_addr = net_slow_ip[iface]
    local speed
    if oper == "up" then
      if iftype == "wifi" then
        speed = net_slow_wifi_speed[iface]
      else
        -- Ethernet speed is a plain sysfs read (no subprocess), so it
        -- stays live every call rather than going through the slow cache.
        speed = get_speed_mbps(iface, iftype)
      end
    end

    local rx_bytes, tx_bytes = get_iface_io_bytes(iface)
    local rx_str, tx_str = nil, nil

    if oper ~= "down" and rx_bytes ~= nil and tx_bytes ~= nil then
      if net_last_time ~= nil and net_last_bytes[iface] then
        local dt = now - net_last_time
        if dt > 0 then
          local prev = net_last_bytes[iface]
          local rx_rate = math.max(0, (rx_bytes - prev[1]) / dt)
          local tx_rate = math.max(0, (tx_bytes - prev[2]) / dt)
          rx_str = format_rate(rx_rate)
          tx_str = format_rate(tx_rate)
        end
      end
      net_last_bytes[iface] = { rx_bytes, tx_bytes }
    else
      rx_str, tx_str = nil, nil
    end

    routes[#routes + 1] = {
      iface = iface,
      ip = nonnull(ip_addr),
      ["type"] = iftype,
      speed = nonnull(speed),
      rx = nonnull(rx_str),
      tx = nonnull(tx_str),
    }
  end

  net_last_time = now

  local overall_status
  if any_up then
    overall_status = "up"
  elseif any_limited then
    overall_status = "limited"
  else
    overall_status = "down"
  end

  local tooltip
  if overall_status == "down" or #routes == 0 then
    tooltip = "Network Offline"
  else
    local first = routes[1]
    local rx = first.rx
    local tx = first.tx
    if rx == NULL or rx == nil then
      rx = "-"
    end
    if tx == NULL or tx == nil then
      tx = "-"
    end
    tooltip = string.format("\u{2193}%s \u{2191}%s", rx, tx)
    for _, r in ipairs(routes) do
      local iface = r.iface or "unknown"
      local ip = r.ip
      if ip == NULL or ip == nil then
        ip = "no ip"
      end
      tooltip = tooltip .. "\n" .. iface .. ": " .. ip
    end
  end

  return { status = overall_status, tooltip = tooltip, routes = routes }
end

local function get_sound_state()
  local function pamixer_flag(flag)
    local out = sh("pamixer " .. flag .. " 2>/dev/null")
    if not out then
      return nil
    end
    return out:gsub("^%s+", ""):gsub("%s+$", "")
  end

  local percent, mute, sink = nil, nil, nil

  local pout = pamixer_flag("--get-volume")
  if pout then
    local num = tonumber(pout:match("^(%-?%d+)"))
    if num then
      percent = math.max(0, math.min(100, num))
    end
  end

  local mout = pamixer_flag("--get-mute")
  if mout ~= nil then
    mute = (mout:lower() == "true")
  end

  local sout = pamixer_flag("--get-default-sink")
  if sout then
    -- Output ends with: INDEX "name" "description"
    local names = {}
    for q in sout:gmatch('"([^"]*)"') do
      names[#names + 1] = q
    end
    if #names > 0 then
      sink = names[#names]
    else
      local last = sout:match("([^\n]+)$")
      sink = last or sout
    end
  end

  local vol = tostring(percent) .. "%"
  local supp = {}
  if mute then
    supp[#supp + 1] = string.format("Muted (%s)", vol)
  else
    supp[#supp + 1] = "Volume: " .. vol
  end
  if sink then
    supp[#supp + 1] = "Sink: " .. sink
  end

  return {
    percent = nonnull(percent),
    mute = mute or false,
    sink = nonnull(sink),
    tooltip = table.concat(supp, "\n"),
  }
end

-- ------------------------------------------------ state + emit
local state = {
  cpu = {
    percent = 0,
    per_core = {},
    freq_mhz = NULL,
    load_avg = NULL,
    tooltip = "CPU: 0%",
  },
  ram = {
    percent = 0,
    used = "0B",
    total = "0B",
    available = "0B",
    swap_percent = 0,
    swap_used = "0B",
    swap_total = "0B",
    speed_mhz = NULL,
    tooltip = "RAM: 0%",
  },
  net = {
    status = "down",
    tooltip = "Network Offline",
    routes = {},
  },
  sound = {
    percent = NULL,
    mute = false,
    sink = NULL,
    tooltip = "Volume: unknown",
  },
}

local function emit()
  io.write(cjson.encode(state) .. "\n")
  io.stdout:flush()
end

local CPU_INTERVAL = 2.0
local SOUND_INTERVAL = 1.0
local INOTIFY_RETRY_INTERVAL = 30.0 -- backoff between (re)spawn attempts

-- ------------------------------------------------ inotifywait child
-- Returns pid, read_fd on success, or nil, nil if the fork/exec setup
-- itself failed outright (pipe/fork syscall failure, not inotifywait
-- failing later).
local function spawn_inotify()
  local r, w = posix.pipe()
  if not r or not w then
    return nil, nil
  end
  local pid = posix.fork()
  if pid == nil then
    posix.close(r)
    posix.close(w)
    return nil, nil
  end
  if pid == 0 then
    posix.dup2(w, unistd.STDOUT_FILENO)
    local nullfd = posix.open("/dev/null", posix.O_WRONLY)
    if nullfd then
      posix.dup2(nullfd, unistd.STDERR_FILENO)
      posix.close(nullfd)
    end
    posix.close(r)
    posix.close(w)
    local ok, err = posix.execp(
      "inotifywait",
      { "inotifywait", "-m", "-e", "modify", "/run/systemd/netif/state" }
    )
    if not ok then
      io.stderr:write("inotifywait: " .. tostring(err) .. "\n")
      os.exit(1)
    end
  end
  posix.close(w)
  return pid, r
end

-- ------------------------------------------------ main loop
local function main()
  local ram_speed_mhz = get_ram_speed_mhz()

  -- seed global state copy with all keys (null defaults)
  local prev_cpu_times = read_cpu_times()

  -- initial emission
  state.net = check_net_status(true)
  emit()

  -- net_fd is nil whenever we have no live inotifywait child to poll on.
  -- We (re)spawn opportunistically, but never more often than
  -- INOTIFY_RETRY_INTERVAL, so a persistently-failing child (missing
  -- binary, watched path doesn't exist, permissions, ...) can never turn
  -- into a tight loop -- it just falls back to picking up network
  -- changes on the regular CPU_INTERVAL cadence below instead.
  local inotify_pid = nil
  local net_fd = nil
  local next_inotify_attempt = 0 -- attempt immediately on first iteration

  local next_cpu = mono_sec() + CPU_INTERVAL
  local next_sound = mono_sec() + SOUND_INTERVAL

  while true do
    local now = mono_sec()

    if net_fd == nil and now >= next_inotify_attempt then
      inotify_pid, net_fd = spawn_inotify()
      -- Whether this attempt succeeded or not, don't try again for a
      -- while: a child that exits immediately (e.g. because the watched
      -- path doesn't exist) would otherwise cause an attempt-per-loop
      -- storm identical to the original bug.
      next_inotify_attempt = mono_sec() + INOTIFY_RETRY_INTERVAL
    end

    if now >= next_cpu then
      local cur_times = read_cpu_times()
      local overall_pct = 0
      local per_core = {}
      for label, cur in pairs(cur_times) do
        local prev = prev_cpu_times[label] or cur
        local d_idle = cur.idle - prev.idle
        local d_total = cur.total - prev.total
        local pct = 0
        if d_total > 0 then
          pct = math.floor((1 - d_idle / d_total) * 100 + 0.5)
        end
        if label == "cpu" then
          overall_pct = pct
        else
          per_core[tonumber(label:match("^cpu(.*)$")) or -1] = pct
        end
      end
      prev_cpu_times = cur_times

      local keys = {}
      for k in pairs(per_core) do
        keys[#keys + 1] = k
      end
      table.sort(keys)
      local per_core_list = {}
      for _, k in ipairs(keys) do
        per_core_list[#per_core_list + 1] = per_core[k]
      end

      local freq_mhz = get_cpu_freq_mhz()
      local load_avg = get_load_avg()

      local cpu_state = {
        percent = overall_pct,
        per_core = per_core_list,
        freq_mhz = nonnull(freq_mhz),
        load_avg = nonnull(load_avg),
        tooltip = build_cpu_tooltip(overall_pct, per_core_list, freq_mhz, load_avg),
      }

      -- RAM
      local meminfo = {}
      local f = io.open("/proc/meminfo")
      if f then
        for line in f:lines() do
          local k, v = line:match("^([^:]+):%s*(%d+)")
          if k and v then
            meminfo[k] = tonumber(v)
          end
        end
        f:close()
      end

      local total_kb = meminfo.MemTotal or 0
      local avail_kb = meminfo.MemAvailable or 0
      local used_kb = math.max(0, total_kb - avail_kb)
      local ram_pct = 0
      if total_kb > 0 then
        ram_pct = math.floor((1 - avail_kb / total_kb) * 100 + 0.5)
      end

      local swap_total_kb = meminfo.SwapTotal or 0
      local swap_free_kb = meminfo.SwapFree or 0
      local swap_used_kb = math.max(0, swap_total_kb - swap_free_kb)
      local swap_pct = 0
      if swap_total_kb > 0 then
        swap_pct = math.floor(swap_used_kb / swap_total_kb * 100 + 0.5)
      end

      local used_fmt = format_bytes(used_kb)
      local total_fmt = format_bytes(total_kb)
      local avail_fmt = format_bytes(avail_kb)
      local swap_used_fmt = format_bytes(swap_used_kb)
      local swap_total_fmt = format_bytes(swap_total_kb)

      local ram_state = {
        percent = ram_pct,
        used = used_fmt,
        total = total_fmt,
        available = avail_fmt,
        swap_percent = swap_pct,
        swap_used = swap_used_fmt,
        swap_total = swap_total_fmt,
        speed_mhz = nonnull(ram_speed_mhz),
        tooltip = build_ram_tooltip(
          ram_pct,
          used_fmt,
          total_fmt,
          avail_fmt,
          swap_pct,
          swap_used_fmt,
          swap_total_fmt,
          ram_speed_mhz
        ),
      }

      state.cpu = cpu_state
      state.ram = ram_state
      -- Net status is always refreshed here too, so even with inotify
      -- permanently unavailable we still pick up link changes within
      -- CPU_INTERVAL seconds.
      state.net = check_net_status()
      emit()
      next_cpu = mono_sec() + CPU_INTERVAL
    end

    if now >= next_sound then
      state.sound = get_sound_state()
      emit()
      next_sound = mono_sec() + SOUND_INTERVAL
    end

    -- Poll inotifywait for link-state changes (timeout in ms). If we
    -- have no live child right now, still sleep until the next
    -- scheduled piece of work (or the next respawn attempt) instead of
    -- busy-looping.
    local wake_at = math.min(next_cpu, next_sound)
    if net_fd == nil then
      wake_at = math.min(wake_at, next_inotify_attempt)
    end
    local until_next = wake_at - mono_sec()
    if until_next < 0 then
      until_next = 0
    end
    local timeout_ms = math.floor(until_next * 1000 + 0.5)

    local fds = {}
    if net_fd ~= nil then
      fds[net_fd] = { events = { IN = true } }
    end

    local nready = poll(fds, timeout_ms)
    if net_fd ~= nil and nready and nready > 0 then
      local revents = fds[net_fd].revents
      if revents and (revents.IN or revents.HUP or revents.ERR) then
        local data = unistd.read(net_fd, 8192)
        if data and #data > 0 then
          -- An actual link-state change: force a full re-probe rather
          -- than waiting out the slow-refresh timer, since this is
          -- exactly the moment the cached IP/speed could be stale.
          state.net = check_net_status(true)
          emit()
        else
          -- Empty read on a "ready" fd means the write end closed, i.e.
          -- the inotifywait child exited (crashed, watched path missing,
          -- binary not found, etc). Reap it, drop the fd, and don't
          -- touch it again until the next backed-off retry -- this is
          -- the fix for the tight busy-loop: without this branch, poll()
          -- would report this dead fd as "ready" forever, on every
          -- single iteration, with an effectively-zero timeout.
          unistd.close(net_fd)
          if inotify_pid then
            pcall(posix.wait, inotify_pid)
          end
          net_fd = nil
          inotify_pid = nil
          next_inotify_attempt = mono_sec() + INOTIFY_RETRY_INTERVAL
        end
      end
    end
  end
end

main()
