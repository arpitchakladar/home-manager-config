{ pkgs, lib, ... }:

{
  # Takes a list of extension attribute sets and generates a bash script to check for updates.
  # Expected attribute set format per extension:
  # {
  #   pname = "extension-name";
  #   owner = "github-owner";
  #   repo = "github-repo";
  #   version = "current-pinned-version";
  #   updateType = "release" | "tag";
  #   tagPrefix = "v"; # (Optional)
  # }
  mkUpdateScript =
    { extensions }:
    pkgs.writeShellApplication {
      name = "check-chromium-extension-updates";
      runtimeInputs = [
        pkgs.curl
        pkgs.jq
      ];
      text = ''
        echo "🔍 Checking for Chromium extension updates..."
        echo "----------------------------------------------"
        echo ""

        ${lib.concatMapStringsSep "\n" (
          ext:
          let
            isTag = (ext.updateType or "release") == "tag";
            apiEndpoint =
              if isTag then
                "https://api.github.com/repos/${ext.owner}/${ext.repo}/tags"
              else
                "https://api.github.com/repos/${ext.owner}/${ext.repo}/releases/latest";

            # jq filter: grab the newest tag name from the tags array, or the tag_name from the release object
            jqFilter = if isTag then ".[0].name" else ".tag_name";
          in
          ''
            # Fetch from GitHub API
            HTTP_RESPONSE=$(curl -sL -w "%{http_code}" "https://api.github.com/repos/${ext.owner}/${ext.repo}")

            LATEST_RAW=$(curl -sL --fail "${apiEndpoint}" | jq -r '${jqFilter}')

            if [ -z "$LATEST_RAW" ] || [ "$LATEST_RAW" == "null" ]; then
              echo "❌ [${ext.pname}] Failed to fetch data from GitHub API."
            else
              # Strip prefix if one is specified
              PREFIX="${ext.tagPrefix or ""}"
              LATEST_STRIPPED="''${LATEST_RAW#$PREFIX}"

              if [ "$LATEST_STRIPPED" != "${ext.version}" ]; then
                echo "⚠️  [${ext.pname}] Update available: ${ext.version} -> $LATEST_STRIPPED"
                echo "    Repo: https://github.com/${ext.owner}/${ext.repo}"
                echo ""
              else
                echo "✅ [${ext.pname}] Up to date (${ext.version})"
              fi
            fi
          ''
        ) extensions}

        echo "----------------------------------------------"
        echo "Done!"
      '';
    };
}
