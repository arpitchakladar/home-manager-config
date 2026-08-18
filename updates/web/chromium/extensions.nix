{ pkgs, lib, ... }:

let
  extensions = import ../../../modules/web/chromium/extensions/metadata.nix;
in
{
  mkUpdateScript = pkgs.writeShellApplication {
    name = "check-chromium-extension-updates";
    runtimeInputs = [
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      echo "Checking for Chromium extension updates..."
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
          # Check ${ext.pname}
          LATEST_RAW=$(curl -sL --fail "${apiEndpoint}" | jq -r '${jqFilter}')

          if [ -z "$LATEST_RAW" ] || [ "$LATEST_RAW" == "null" ]; then
            echo "FAIL [${ext.pname}] Failed to fetch data from GitHub API."
          else
            # Strip prefix if one is specified
            PREFIX="${ext.tagPrefix}"
            LATEST_STRIPPED="''${LATEST_RAW#$PREFIX}"

            if [ "$LATEST_STRIPPED" != "${ext.version}" ]; then
              echo "UPDATE [${ext.pname}] ${ext.version} -> $LATEST_STRIPPED"
              echo "  Repo: https://github.com/${ext.owner}/${ext.repo}"
              echo ""
            else
              echo "OK [${ext.pname}] ${ext.version}"
            fi
          fi
        ''
      ) extensions}

      echo "----------------------------------------------"
      echo "Done!"
    '';
  };
}
