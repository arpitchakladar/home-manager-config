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
