{
  extLib,
  ...
}:
let
  pname = "searxng-home";
  owner = "arpitchakladar";
  repo = "searxng-home";
  version = "0.2.0";
in
{
  inherit pname version;
  id = "gmkjafoflhifgcnmpomcoakhahmepfkc";
  drv = extLib.fetchUnpackedExtension {
    inherit pname version;
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/chrome-v${version}.zip";
    hash = "sha256-fbXxtjTa8GKxylc5JS3GVj/oC+xCI5VJkE3bBpA2CbY=";
    isCrx = false;
    extensionKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2cDXvyOi1QgsWlC8LnwyXIV7EZ6yWLKvKCNBn8DPD4DwJgw221wqo6R9p/qnsnqAuveZrV/ApRq6MdzAclkWTGKyCJCRdJGBG/XM3BVfMBkuLXaLrvpFf8p/mDcAP37yOh0Z45XMTr55Y9ifnNH6Wu+3zAaASJlkBuGZ5ygbcUYcomcKjs7qfqxqY8Qe9ovIuLOQely+X9i+Qa6bZ0GJUTgXiKHckgY/43l+H+gs9V91he8qaSubzWPqwbYk8aWhTmjQTeR0vfUP+1/XBESt4u4NGxHsuk+ZwwbL6ThYRbzgj/UbvVGVQsanhIwODdJte51XanEo475Woal31++uxwIDAQAB";
  };
}
