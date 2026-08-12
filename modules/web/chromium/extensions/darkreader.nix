{
  extLib,
  ...
}:
let
  pname = "darkreader";
  owner = "darkreader";
  repo = "darkreader";
  version = "4.9.129";
  checkedVersion = extLib.checkExtensionVersion {
    inherit
      pname
      owner
      repo
      version
      ;
    tagPrefix = "v";
    urlTemplate = "https://github.com/${owner}/${repo}/releases/download/v<version>/darkreader-chrome.zip";
  };
in
{
  inherit pname;
  version = checkedVersion;
  id = "nfkppknaehpcafkbgmhfhkpapflndfip";
  drv = extLib.fetchUnpackedExtension {
    inherit pname;
    version = checkedVersion;
    url = "https://github.com/${owner}/${repo}/releases/download/v${checkedVersion}/darkreader-chrome.zip";
    hash = "sha256-Yuhgoxp5MRgVMEEbOaQvRsVjYn/iaBhcHujipBX5rUE=";
    extensionKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8xN0p4CHkthdkB6imIb+8T2xsNSH9eeFAy7NhP3xAO1ML6FJyOFroabQIG6HcV7miXmJamY7zmE96QgEEvGqQ18+g+RsfvriJp0LRXi95TJBdCXoMiW348bWmue0Jk+/rhzWijMn/z/5fDnrZl0xjKU7MAXzW9dWfiTeIBc4wlk21zjGJxiG0uM1YAywe3jW8g0QCBga9iTaN67D+sBbBs4HmPa3xIbtPTAgqt1LDEk2T7IseoUia8MwxATWKWFegW6legMkPLVWH9jQ+x2ZbjtDP9GXk+1YqqWQUll1Xmal7C9ljeagkM5nhxgttAQoWBMPMJFwr7VN3AXtNXXPWQIDAQAB";
  };
}
