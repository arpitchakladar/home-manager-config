{
  config,
  lib,
  pkgs,
  ...
}:

# bat - a cat clone with wings
{
  options.tools.bat = {
    enable = lib.mkEnableOption "Enables bat.";
  };

  config = lib.mkIf config.tools.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "base16";
      };
      themes = {
        base16 = {
          src = pkgs.runCommand "bat-base16-theme" { } ''
            mkdir -p $out
            cp ${config.scheme { template = ./base16.mustache.tmTheme; }} $out/base16.tmTheme
          '';
          file = "base16.tmTheme";
        };
      };
    };
  };
}
