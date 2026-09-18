#!/usr/bin/env luajit
-- Strip JSON comments and trailing commas from a manifest, inject the
-- extension's public key, and rewrite it.
local dkjson = require("dkjson")

local manifest_path = assert(arg[1], "usage: inject_extension_key.lua <manifest> <extension_key>")
local extension_key = assert(arg[2], "usage: inject_extension_key.lua <manifest> <extension_key>")

local manifest_file = assert(io.open(manifest_path, "r"))
local manifest_content = manifest_file:read("*a")
manifest_file:close()

-- Hand-rolled scanner that removes // and /* */ comments and mid-JSON
-- trailing commas while respecting string literals (including escapes).
local sanitized_chunks = {}
local character_position = 1
local content_length = #manifest_content
local inside_string_literal = false

local function trim_trailing_comma()
  while #sanitized_chunks > 0 do
    local last_chunk = sanitized_chunks[#sanitized_chunks]
    if last_chunk ~= " " and last_chunk ~= "\t" and last_chunk ~= "\n" and last_chunk ~= "\r" then
      break
    end
    sanitized_chunks[#sanitized_chunks] = nil
  end
  if #sanitized_chunks > 0 and sanitized_chunks[#sanitized_chunks] == "," then
    sanitized_chunks[#sanitized_chunks] = nil
  end
end

while character_position <= content_length do
  local current_character = manifest_content:sub(character_position, character_position)
  if inside_string_literal then
    sanitized_chunks[#sanitized_chunks + 1] = current_character
    if current_character == "\\" and character_position < content_length then
      -- Preserve escaped characters verbatim so escape sequences are not split.
      sanitized_chunks[#sanitized_chunks + 1] = manifest_content:sub(character_position + 1, character_position + 1)
      character_position = character_position + 2
    else
      if current_character == '"' then
        inside_string_literal = false
      end
      character_position = character_position + 1
    end
  else
    local character_pair = manifest_content:sub(character_position, character_position + 1)
    if current_character == '"' then
      inside_string_literal = true
      sanitized_chunks[#sanitized_chunks + 1] = current_character
      character_position = character_position + 1
    elseif character_pair == "//" then
      local line_end_position = manifest_content:find("\n", character_position) or (content_length + 1)
      character_position = line_end_position
    elseif character_pair == "/*" then
      local comment_end_position = manifest_content:find("%*/", character_position + 2)
      if not comment_end_position then
        break
      end
      character_position = comment_end_position + 2
    elseif current_character == "]" or current_character == "}" then
      trim_trailing_comma()
      sanitized_chunks[#sanitized_chunks + 1] = current_character
      character_position = character_position + 1
    else
      sanitized_chunks[#sanitized_chunks + 1] = current_character
      character_position = character_position + 1
    end
  end
end

local manifest_data = dkjson.decode(table.concat(sanitized_chunks))
manifest_data.key = extension_key

manifest_file = assert(io.open(manifest_path, "w"))
manifest_file:write(dkjson.encode(manifest_data, { indent = true }))
manifest_file:close()
