#!/usr/bin/env luajit
-- inject_extension_key: strip JSON comments and trailing commas from a
-- manifest, inject the extension's public key, and rewrite it.
local dkjson = require("dkjson")

local manifest_path = assert(arg[1], "usage: inject_extension_key.lua <manifest> <ext_key>")
local ext_key = assert(arg[2], "usage: inject_extension_key.lua <manifest> <ext_key>")

local f = assert(io.open(manifest_path, "r"))
local content = f:read("*a")
f:close()

-- Hand-rolled scanner that removes // and /* */ comments and mid-JSON
-- trailing commas while respecting string literals (including escapes).
local sb = {}
local i, n = 1, #content
local in_string = false

local function trim_trailing_comma()
  while #sb > 0 and (sb[#sb] == " " or sb[#sb] == "\t" or sb[#sb] == "\n" or sb[#sb] == "\r") do
    sb[#sb] = nil
  end
  if #sb > 0 and sb[#sb] == "," then
    sb[#sb] = nil
  end
end

while i <= n do
  local c = content:sub(i, i)
  if in_string then
    sb[#sb + 1] = c
    if c == "\\" and i < n then
      sb[#sb + 1] = content:sub(i + 1, i + 1)
      i = i + 2
    else
      if c == '"' then
        in_string = false
      end
      i = i + 1
    end
  else
    local two = content:sub(i, i + 1)
    if c == '"' then
      in_string = true
      sb[#sb + 1] = c
      i = i + 1
    elseif two == "//" then
      local nl = content:find("\n", i) or (n + 1)
      i = nl
    elseif two == "/*" then
      local close = content:find("%*/", i + 2)
      if not close then
        break
      end
      i = close + 2
    elseif c == "]" or c == "}" then
      trim_trailing_comma()
      sb[#sb + 1] = c
      i = i + 1
    else
      sb[#sb + 1] = c
      i = i + 1
    end
  end
end

local data = dkjson.decode(table.concat(sb))
data.key = ext_key

f = assert(io.open(manifest_path, "w"))
f:write(dkjson.encode(data, { indent = true }))
f:close()
