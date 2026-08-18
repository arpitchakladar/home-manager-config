{
  extLib,
  ...
}:
let
  meta = import ./metadata.nix;
in
{
  inherit (meta) pname version;
  id = "jbaodoonnfhdccelcpnekimkijgdfjhl";
  drv = extLib.fetchUnpackedExtension {
    inherit (meta) pname version;
    url = "https://github.com/${meta.owner}/${meta.repo}/releases/download/${meta.version}/browserpass-chromium-${meta.version}.zip";
    hash = "sha256-WBpPTtec7zJPWM1xNKVxWWW/sB1aIuPecp5fUTWRE8c=";
    extensionKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv8xL6YhF7YTUE57jhme0vyJi4FZGXDBLV93QYWv6yrYbmczkM4aEOp4FWm63NnkJ8aGZ/0uL0rHmB4qo36awso/1L9XGJaBbQAQuOv/uIPAE18STJ4EtXA1hYDMGbkkr4fZHYJTH3GmoeajZYfp/cu8qc0cK4P5FVq67qwYSD4uFQJRJKuX8jM4lzO8dLH/tJsN3KwlfeSA8xvS2jiIJHtCKc6XqMrOCCfSmI8uILfg06fv46VOoVDH91dlZguOYANAJDW69uCY9YcvyVEmmf6DUnvmkrziDtV2O4/Af6nt7R5JHOcVcqVScoXJG9sfd4KATMcgoZj3fy19+R/4GvwIDAQAB";
  };
}
