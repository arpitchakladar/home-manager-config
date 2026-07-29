{
  extLib,
  ...
}:
let
  pname = "dark-mode";
  owner = "code-charity";
  repo = "dark-mode";
  version = "3.3.11";
  checkedVersion = extLib.checkExtensionVersion {
    inherit
      pname
      owner
      repo
      version
      ;
    tagPrefix = "v";
    urlTemplate = "https://github.com/${owner}/${repo}/archive/refs/tags/v<version>.zip";
  };
in
{
  inherit pname;
  version = checkedVersion;
  id = "ifpghghnlimndidoppdkdnbljddikfoj";
  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/archive/refs/tags/v${checkedVersion}.zip";
    hash = "sha256-Lt3T8i0ylV0l+T0eqnzs6veBcOpizhP79LgSkUx4xI8=";
  };
}
