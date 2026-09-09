#!/usr/bin/env luajit
-- Checks for updated Chromium extensions against their GitHub releases/tags.

local extensions = {
  -- NOTE: replaced by the derivation build step, with the
  -- detailed list of all extensions that we need to check
  --@@EXTENSIONS@@--
}

local function printf(fmt, ...)
  io.write(string.format(fmt, ...))
end

print("Checking for Chromium extension updates...")
print("----------------------------------------------")
print("")

for _, ext in ipairs(extensions) do
  local isTag = ext.updateType == "tag"
  local endpoint
  local jqFilter
  if isTag then
    endpoint = string.format("https://api.github.com/repos/%s/%s/tags", ext.owner, ext.repo)
    jqFilter = ".[0].name"
  else
    endpoint = string.format("https://api.github.com/repos/%s/%s/releases/latest", ext.owner, ext.repo)
    jqFilter = ".tag_name"
  end

  local proc = io.popen(string.format("curl -sL --fail %q | jq -r %q", endpoint, jqFilter))
  local latestRaw = (proc and proc:read("*a") or ""):gsub("%s+$", "")
  if proc then
    proc:close()
  end

  if latestRaw == "" or latestRaw == "null" then
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

print("----------------------------------------------")
print("Done!")
