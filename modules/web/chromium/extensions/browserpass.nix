{
  extLib,
  ...
}:
let
  pname = "browserpass";
  owner = "browserpass";
  repo = "browserpass-extension";
  version = "3.12.0";
  checkedVersion = extLib.checkExtensionVersion {
    inherit
      pname
      owner
      repo
      version
      ;
    tagPrefix = "";
    urlTemplate = "https://github.com/${owner}/${repo}/releases/download/<version>/browserpass-webstore-<version>.crx";
  };
in
{
  inherit pname;
  version = checkedVersion;
  # Stable webstore ID — only holds if the crx's manifest.json embeds "key".
  # Verify at chrome://extensions after switching; update if it drifts.
  id = "klfoddkbhleoaabpmiigbmpbjfljimgb";
  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/releases/download/${checkedVersion}/browserpass-webstore-${checkedVersion}.crx";
    hash = "sha256-NfLbEe2EBctmntJqbsIpwm2WRFdo8q6yjWGjVK2MmFE=";
    isCrx = true;
  };
}
