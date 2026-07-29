{
  extLib,
  ...
}:
let
  pname = "aria2-explorer";
  owner = "alexhua";
  repo = "Aria2-Explorer";
  version = "2.8.2";
  checkedVersion = extLib.checkExtensionVersion {
    inherit
      pname
      owner
      repo
      version
      ;
    tagPrefix = "v";
    urlTemplate = "https://github.com/${owner}/${repo}/releases/download/v<version>/A2E-v<version>.crx";
  };
in
{
  inherit pname;
  version = checkedVersion;
  id = "dkcfilkhokojanlmgpbmjidiidoebnbm";
  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/releases/download/v${checkedVersion}/A2E-v${checkedVersion}.crx";
    hash = "sha256-ljTgKd9QJTRJ11rlNx+PTynlQvdLW3IEoYNnCeOU2K8=";
    isCrx = true;
  };
}
