{
  config,
  lib,
  pkgs,
  ...
}:

# bat - a cat clone with wings
{
  config = lib.mkIf config.programs.bat.enable {
    programs.bat = {
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
