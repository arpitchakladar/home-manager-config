{ config, ... }:
let
  cfg = config.web.chromium;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.file-management.ouch.enable;
      message = ''
        web.chromium.enable is true but file-management.ouch.enable is not.
        chromium extension fetching requires ouch to decompress extension archives. Please enable file-management.ouch.
      '';
    }
  ];
}
