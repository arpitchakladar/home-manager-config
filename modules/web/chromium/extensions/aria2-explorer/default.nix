{
  extLib,
  ...
}:
let
  meta = import ./metadata.nix;
in
{
  inherit (meta) pname version;
  id = "hhndckjijagcbbljjhjcbnpjhamkkcjl";
  drv = extLib.fetchUnpackedExtension {
    inherit (meta) pname version;
    url = "https://github.com/${meta.owner}/${meta.repo}/archive/refs/tags/v${meta.version}.zip";
    hash = "sha256-4+SkvgWrELcohpv724YEtvSQSDCmjphkk8bvYggxVag=";
    extensionKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArOOLc1LawtEonls6j4P/KQyUAGO3KJcE9uAU9WV/tBIX6ulXivZypUAXC6Lokv56Bjnc08t/wUH8Xph0Gya4UzjSbZkdtR94yksY9mq5g/8df4p4v29SO+E6efQyXGyImEzFSHsNP4gu8akB5xT8O//51XRAXsMBVgUUTuUAlpnwd25Yy1tpQwqjbSV3gvAMo+a6+y0dBfXJ9fjwAYBwvx4cONSNjirIuyOG5r5FI5TaGMK+aV1xwNsDE59dyDkYL2f2mm1kN/2xMcayJrskVxtOcy18ijjXzyRJvNyhkLM2c5tEZHUkIlEgTjbJruF8EKrj2sCnodt1jknD0BSr1wIDAQAB";
  };
}
