{
  extLib,
  ...
}:
let
  pname = "vimium";
  owner = "philc";
  repo = "vimium";
  version = "2.4.2";
  checkedVersion = extLib.checkExtensionVersionByTag {
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
  id = "ojbnfglfbelfbgfjlkehclgfkdkkjkdj";
  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/archive/refs/tags/v${checkedVersion}.zip";
    hash = "sha256-Q+Tus7nl7TiuVJ4hn8vYg9L2cC4NhqWSOr5WKD0RSq0=";
    extensionKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqUw4MXlUYAqIQqJ1Gb/RH7RdgVjekKed1aoJS1OPM5C9EFfvVlj0/eIf8dVbCMKc7ThRYYJkZPqFNN38T0LtnBJbvdiJztL/nGueJT7GupXisIzJ9s17X+HpogODouDY7qHldQRw/7qnrBe0NeNxWVeUOH9PmHi8nBTZ3JRygS9svZ1BvY0ZkPZyNDTEsXCbb+fkSOOkjqDNqtt98eFJhPGZ0W+cn3KgTdr+rC0rqfacwfu41dpmQPEirOFtshs8DywoI+L66UtqVfwhBNdb3+JN7oeDs4HNFjCPbqOTSKKCng+nNndpIen2CKYUuYztvmrrRdQeEv5i3l7/MFrRXQIDAQAB";
  };
}
