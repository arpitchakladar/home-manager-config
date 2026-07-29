{
  extLib,
  ...
}:
let
  pname = "ublock-origin";
  owner = "gorhill";
  repo = "uBlock";
  version = "1.72.2";
  checkedVersion = extLib.checkExtensionVersion {
    inherit
      pname
      owner
      repo
      version
      ;
    tagPrefix = "";
    urlTemplate = "https://github.com/${owner}/${repo}/releases/download/<version>/uBlock0_<version>.chromium.zip";
  };
in
{
  inherit pname;
  version = checkedVersion;
  id = "nnpdegnhelmjgchicpfdigllmhgpndeg"; # unpacked, ID derives from manifest key at load time
  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/releases/download/${checkedVersion}/uBlock0_${checkedVersion}.chromium.zip";
    hash = "sha256-0QTKxOH0jXaxw/+Irt4uqoJpgUrgbMnIUNJ6+1J05TM=";
  };
}
