# Browserpass - browser extension providing it access to your password store
{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.web.chromium.enable && config.security.gopass.enable) {
    programs.browserpass = {
      enable = true;
      browsers = [ "chromium" ];
    };
  };
}
