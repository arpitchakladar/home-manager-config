#!/usr/bin/env luajit
-- niri-status: emit {workspaces: [...], active_windows: [...]} as one JSON
-- object per line, driven by a single niri event-stream subscription.
--
-- This replaces the old activate-windows.lua + workspaces.lua pair. Those
-- ran as two separate long-lived processes, each independently subscribed
-- to niri's event-stream and, on every relevant event, independently
-- re-fetched both `niri msg -j windows` and `niri msg -j workspaces` via a
-- shelled-out io.popen. Combined that was up to 8 process spawns per single 
-- event across both scripts. Here there's one event-stream subscription, 
-- and one shared windows/workspaces fetch per event, significantly reducing 
-- the total number of spawned processes and resting children.
--
-- The event-stream subscription is wrapped in a reconnect loop: if niri
-- restarts, sleeps, or its IPC socket otherwise drops, `niri msg -j
-- event-stream` hits EOF and would normally kill this whole script (which
-- kills eww's deflisten listener along with it, requiring a manual eww
-- restart). Instead we detect the EOF, back off briefly, and keep retrying
-- until niri is reachable again, re-emitting fresh state on every
-- reconnect so the bar catches up automatically.

local cjson = require("cjson")

local Gio, GioUnix, Gtk, Gdk, icon_theme = nil, nil, nil, nil, nil
local DesktopAppInfo = nil
do
  local lgi_ok, lgi = pcall(require, "lgi")
  if lgi_ok then
    local gio_ok, gio = pcall(function() return lgi.Gio end)
    if gio_ok then Gio = gio end

    local giounix_ok, giounix = pcall(function() return lgi.GioUnix end)
    if giounix_ok then GioUnix = giounix end

    local gtk_ok, gtk = pcall(function() return lgi.Gtk end)
    if gtk_ok then Gtk = gtk end

    local gdk_ok, gdk = pcall(function() return lgi.Gdk end)
    if gdk_ok then Gdk = gdk end

    DesktopAppInfo = (GioUnix and GioUnix.DesktopAppInfo) or (Gio and Gio.DesktopAppInfo)

    if Gtk then
      local get_ok, theme = pcall(Gtk.IconTheme.get_default)
      if get_ok and theme then
        icon_theme = theme
      elseif Gdk then
        local disp_ok, display = pcall(Gdk.Display.get_default)
        if disp_ok and display then
          local get_ok2, theme2 = pcall(Gtk.IconTheme.get_for_display, display)
          if get_ok2 and theme2 then
            icon_theme = theme2
          end
        end
      end
    end
  end
end

local icon_cache = {}

local function g_list_to_table(gl)
  if gl == nil then return {} end
  if type(gl) == "table" then return gl end
  local t = {}
  local cur = gl
  while cur do
    t[#t + 1] = cur.data
    cur = cur.next
  end
  return t
end

local function resolve_icon_path(app_id)
  if not app_id or app_id == "" then return "" end
  if icon_cache[app_id] then return icon_cache[app_id] end

  local icon_path = ""
  if DesktopAppInfo and Gtk and icon_theme then
    local function try_desktop_app_info(desktop_id)
      local ok, info = pcall(DesktopAppInfo.new, desktop_id)
      if ok and info then return info end
      return nil
    end

    local app_info = try_desktop_app_info(app_id .. ".desktop")
                  or try_desktop_app_info(string.lower(app_id) .. ".desktop")

    if not app_info then
      local lc = string.lower(app_id)
      for _, info in ipairs(g_list_to_table(Gio.AppInfo.get_all())) do
        local ok_wm, wm = pcall(function() return info:get_startup_wm_class() end)
        if ok_wm and wm and string.lower(wm) == lc then
          app_info = info
          break
        end
      end
    end

    local gicon = app_info and app_info:get_icon()
    if gicon then
      local ok2, lookup = pcall(icon_theme.lookup_by_gicon, icon_theme, gicon, 24, Gtk.IconLookupFlags.FORCE_SIZE)
      if ok2 and lookup then
        icon_path = lookup:get_filename() or ""
      end
    end
    if icon_path == "" then
      local ok2, lookup = pcall(icon_theme.lookup_icon, icon_theme, app_id, 24, Gtk.IconLookupFlags.FORCE_SIZE)
      if ok2 and lookup then
        icon_path = lookup:get_filename() or ""
      end
    end
  end

  icon_cache[app_id] = icon_path
  return icon_path
end

-- Safely run niri msg without crashing due to luaposix version changes
local function niri_json(command)
  local f = io.popen("niri msg -j " .. command .. " 2>/dev/null")
  if not f then return nil end
  local out = f:read("*a")
  f:close()
  local ok, decoded = pcall(cjson.decode, out)
  if ok then return decoded end
  return nil
end

local function sanitize_utf8(s)
  if type(s) ~= "string" or s == "" then return s end
  local out = {}
  local i, n = 1, #s
  while i <= n do
    local c = s:byte(i)
    local len
    if c < 0x80 then len = 1
    elseif c >= 0xC2 and c <= 0xDF then len = 2
    elseif c >= 0xE0 and c <= 0xEF then len = 3
    elseif c >= 0xF0 and c <= 0xF4 then len = 4
    else len = 0 end

    local valid = len > 0 and (i + len - 1 <= n)
    if valid then
      for k = 1, len - 1 do
        local cc = s:byte(i + k)
        if not cc or cc < 0x80 or cc > 0xBF then valid = false break end
      end
    end

    if valid then
      out[#out + 1] = s:sub(i, i + len - 1)
      i = i + len
    else
      out[#out + 1] = "\239\191\189" -- U+FFFD
      i = i + 1
    end
  end
  return table.concat(out)
end

local function window_sort_key(w)
  local layout = w.layout or {}
  local pos = layout.pos_in_scrolling_layout
  if pos then return { 0, pos[1], pos[2] } end
  return { 1, w.id, 0 }
end

local function lt(a, b)
  for k = 1, math.max(#a, #b) do
    local x, y = a[k], b[k]
    if y == nil then return false end
    if x == nil then return true end
    if x ~= y then return x < y end
  end
  return false
end

-- Ensures cjson turns empty tables into `[]` instead of `{}`
local empty_array = cjson.empty_array or setmetatable({}, { __jsontype = "array" })

local function build_state()
  local workspaces_raw = niri_json("workspaces") or {}
  local windows_raw = niri_json("windows") or {}

  local windows_by_id = {}
  for _, w in ipairs(windows_raw) do
    windows_by_id[w.id] = w
  end

  local active_id
  for _, ws in ipairs(workspaces_raw) do
    if ws.is_active then
      active_id = ws.id
      break
    end
  end

  local on_active = {}
  for _, w in ipairs(windows_raw) do
    if w.workspace_id == active_id then
      on_active[#on_active + 1] = w
    end
  end
  table.sort(on_active, function(a, b)
    return lt(window_sort_key(a), window_sort_key(b))
  end)

  local active_windows_result = {}
  for _, w in ipairs(on_active) do
    active_windows_result[#active_windows_result + 1] = {
      id = w.id,
      title = sanitize_utf8(w.title or ""),
      app_id = sanitize_utf8(w.app_id or ""),
      is_focused = w.is_focused or false,
      icon = resolve_icon_path(w.app_id or ""),
    }
  end
  -- Enforce JSON Array even if empty
  if #active_windows_result == 0 then active_windows_result = empty_array end

  local ws_list = {}
  for _, ws in ipairs(workspaces_raw) do
    ws_list[#ws_list + 1] = ws
  end
  table.sort(ws_list, function(a, b) return a.idx < b.idx end)

  local workspaces_result = {}
  for _, ws in ipairs(ws_list) do
    local active_win = windows_by_id[ws.active_window_id]
    local app_id = (active_win and active_win.app_id) or ""

    local ws_name = (type(ws.name) == "string" and ws.name ~= "userdata: NULL" and ws.name) or ("Workspace " .. tostring(ws.idx))

    local ws_windows = {}
    for _, w in ipairs(windows_raw) do
      if w.workspace_id == ws.id then
        ws_windows[#ws_windows + 1] = w
      end
    end
    table.sort(ws_windows, function(a, b)
      return lt(window_sort_key(a), window_sort_key(b))
    end)

    local lines = { ws_name }
    for idx, w in ipairs(ws_windows) do
      local w_app_id = sanitize_utf8(w.app_id or "")
      local w_title = sanitize_utf8(w.title or "")
      lines[#lines + 1] = string.format("%d. %s: %s", idx, (w_app_id and w_app_id ~= "" and w_app_id) or "unknown", (w_title and w_title ~= "" and w_title) or "(untitled)")
    end

    workspaces_result[#workspaces_result + 1] = {
      idx = ws.idx,
      id = ws.id,
      is_active = ws.is_active or false,
      icon = resolve_icon_path(app_id),
      tooltip = #ws_windows > 0 and table.concat(lines, "\n") or ws_name,
    }
  end
  -- Enforce JSON Array even if empty
  if #workspaces_result == 0 then workspaces_result = empty_array end

  -- Output as a ROOT JSON OBJECT
  return {
    workspaces = workspaces_result,
    active_windows = active_windows_result,
  }
end

local function emit_state()
  local ok, result = pcall(build_state)
  if not ok then
    io.stderr:write(tostring(result) .. "\n")
    return
  end
  local ok2, encoded = pcall(cjson.encode, result)
  if not ok2 then
    io.stderr:write(tostring(encoded) .. "\n")
    return
  end
  print(encoded)
  io.stdout:flush()
end

local RELEVANT_EVENTS = {
  WindowOpenedOrChanged = true, WindowClosed = true, WindowFocusChanged = true,
  WorkspaceActivated = true, WorkspacesChanged = true, WindowsChanged = true,
  WorkspaceUrgencyChanged = true, WorkspaceActiveWindowChanged = true
}

local function sleep(seconds)
  os.execute("sleep " .. tostring(seconds))
end

-- Subscribe to one event-stream session. Returns true if at least one
-- event line was received (i.e. niri was genuinely up and running for a
-- while), false if the pipe produced nothing before EOF (niri unreachable
-- or the socket isn't up yet).
local function run_event_stream_session()
  local proc = io.popen("niri msg -j event-stream 2>/dev/null")
  if not proc then return false end

  local got_any_line = false
  for line in proc:lines() do
    got_any_line = true
    local ok, obj = pcall(cjson.decode, line)
    if ok and obj then
      local key = next(obj)
      if RELEVANT_EVENTS[key] then emit_state() end
    end
  end
  proc:close()
  return got_any_line
end

emit_state()

local retry_delay = 1
while true do
  local got_any_line = run_event_stream_session()

  -- Whether this was niri restarting, waking from sleep, or the socket
  -- just briefly hiccuping: refresh the bar's view of the world as soon
  -- as we notice, rather than waiting for the next real event.
  emit_state()

  if got_any_line then
    -- We were genuinely connected for a while; go back to fast retries
    -- if the connection drops again.
    retry_delay = 1
  else
    -- niri isn't reachable yet (asleep / mid-restart) -- back off so we
    -- don't spawn `niri msg` in a tight loop while waiting for it.
    retry_delay = math.min(retry_delay * 2, 8)
  end

  sleep(retry_delay)
end
