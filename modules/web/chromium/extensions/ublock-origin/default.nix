{
  extLib,
  ...
}:
let
  meta = import ./metadata.nix;
in
{
  inherit (meta) pname version;
  id = "eahmphincfcmmpgkpobpneimcjndlcna";
  drv = extLib.fetchUnpackedExtension {
    inherit (meta) pname version;
    url = "https://github.com/${meta.owner}/${meta.repo}/releases/download/${meta.version}/uBlock0_${meta.version}.chromium.zip";
    hash = "sha256-IsYrwPNe0MXpXR/IMagprxmcfKb9tPhBvgNMJXGc6RE=";
    extensionKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtXfkoFzWOh3Fet9x4L6WY1pw755kt7bFwqd/nmTm5Ptg7d40Qde0tTIhceCFVkwrWTQ3n2/WSpYXoU/UMgSW9anBzoUM0ZXanIdoeHwvL3eMNyx+iyvSrRxee26GwzbZ8J0UvH77KT3rW/iV5ejV4wTxTD3rFr0udkI5bbTPYpmGFOKPD8I3IB6BsoUTKW3XTSLM0fUYggdbDNwQGZvLYwqZzk/vWH/oifHR6CEvdFR51JAdf3tJQhttI6My49Vq6etCi9y5ZLXrMksxcEcIlQKaF2fdlfL1bYXRAVFDsieuAmu3gJPBj65PVJif5A7DfcH8zm8YGPwrJlTjaJQeDQIDAQAB";
  };
}
