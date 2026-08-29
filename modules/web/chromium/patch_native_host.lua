#!/usr/bin/env luajit
-- patch_native_host: set allowed_origins in a native messaging host manifest.
local dkjson = require("dkjson")

local extension_id = assert(arg[1], "usage: patch_native_host.lua <extension_id> <input> <output>")
local input = assert(arg[2], "usage: patch_native_host.lua <extension_id> <input> <output>")
local output = assert(arg[3], "usage: patch_native_host.lua <extension_id> <input> <output>")

local f = assert(io.open(input, "r"))
local content = f:read("*a")
f:close()

local manifest = dkjson.decode(content)
manifest.allowed_origins = { "chrome-extension://" .. extension_id .. "/" }

f = assert(io.open(output, "w"))
f:write(dkjson.encode(manifest, { indent = true }))
f:write("\n")
f:close()
