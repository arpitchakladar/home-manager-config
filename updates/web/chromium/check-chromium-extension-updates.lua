#!/usr/bin/env luajit
-- Checks for updated Chromium extensions against their GitHub releases/tags.

local cjson = require("cjson")
local http_request = require("http.request")

local rawExtensionsString = "@@EXTENSIONS@@"
local extensions = cjson.decode(rawExtensionsString)

local function printf(fmt, ...)
  io.write(string.format(fmt, ...))
end

-- Performs a GET request against the GitHub API and returns the
-- decoded JSON body, or nil plus an error message.
local function githubGetJson(url)
  local req = http_request.new_from_uri(url)
  req.headers:upsert("user-agent", "check-chromium-extension-updates")
  req.headers:upsert("accept", "application/vnd.github+json")

  local headers, stream = req:go(10) -- 10s timeout
  if not headers then
    -- on failure, `stream` actually holds the error message
    return nil, tostring(stream)
  end

  local body, err = stream:get_body_as_string()
  stream:shutdown()
  if not body then
    return nil, err or "no response body"
  end

  local status = headers:get(":status")
  if status ~= "200" then
    return nil, string.format("HTTP %s", tostring(status))
  end

  local ok, decoded = pcall(cjson.decode, body)
  if not ok then
    return nil, "failed to decode JSON response"
  end

  return decoded, nil
end

print("Checking for Chromium extension updates...")
print("----------------------------------------------")
print("")

for _, ext in ipairs(extensions) do
  local isTag = ext.updateType == "tag"
  local endpoint
  if isTag then
    endpoint = string.format("https://api.github.com/repos/%s/%s/tags", ext.owner, ext.repo)
  else
    endpoint = string.format("https://api.github.com/repos/%s/%s/releases/latest", ext.owner, ext.repo)
  end

  local data, err = githubGetJson(endpoint)
  local latestRaw

  if not data then
    printf("FAIL [%s] Failed to fetch data from GitHub API (%s).\n", ext.pname, err)
  else
    latestRaw = isTag and data[1] and data[1].name or data.tag_name

    if latestRaw == nil or latestRaw == "" then
      printf("FAIL [%s] Failed to fetch data from GitHub API.\n", ext.pname)
    else
      local prefix = ext.tagPrefix
      local latest = latestRaw
      if prefix ~= "" and latestRaw:sub(1, #prefix) == prefix then
        latest = latestRaw:sub(#prefix + 1)
      end

      if latest ~= ext.version then
        printf("UPDATE [%s] %s -> %s\n", ext.pname, ext.version, latest)
        printf("  Repo: https://github.com/%s/%s\n", ext.owner, ext.repo)
        print("")
      else
        printf("OK [%s] %s\n", ext.pname, ext.version)
      end
    end
  end
end

print("----------------------------------------------")
print("Done!")
