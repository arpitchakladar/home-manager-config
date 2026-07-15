{
  config,
  lib,
  pkgs,
  ...
}:

# bat - a cat clone with wings
{
  options.terminal.bat = {
    enable = lib.mkEnableOption "Enables bat.";
    package = lib.mkPackageOption pkgs "bat" { };
  };

  config = lib.mkIf config.terminal.bat.enable {
    programs.bat = {
      enable = true;
      package = config.terminal.bat.package;
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
