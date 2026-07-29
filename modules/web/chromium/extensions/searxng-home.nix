{
  lib,
  pkgs,
  extLib,
}:
let
  pname = "searxng-home";
  owner = "arpitchakladar";
  repo = "searxng-home";

  version = "0.1.0";

  checkedVersion = extLib.checkExtensionVersion {
    inherit
      pname
      owner
      repo
      version
      ;
    tagPrefix = "v";
    urlTemplate = "https://github.com/${owner}/${repo}/releases/download/v<version>/chrome-v<version>.zip";
  };
in
{
  inherit pname;
  version = checkedVersion;

  id = "your_extension_id_here";

  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/releases/download/v${checkedVersion}/searxng-home-${checkedVersion}.zip";
    hash = lib.fakeHash;
    isCrx = false;
  };
}
