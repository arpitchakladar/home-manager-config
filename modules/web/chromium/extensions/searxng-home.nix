{
  extLib,
  ...
}:
let
  pname = "searxng-home";
  owner = "arpitchakladar";
  repo = "searxng-home";

  version = "0.2.0";

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

  id = "acoijbpbnodehiibdpmkkhlpmcnabpaa";

  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/releases/download/v${checkedVersion}/chrome-v${checkedVersion}.zip";
    hash = "sha256-fbXxtjTa8GKxylc5JS3GVj/oC+xCI5VJkE3bBpA2CbY=";
    isCrx = false;
  };
}
