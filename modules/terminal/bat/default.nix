# bat - a cat clone with wings
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.terminal.bat = {
    enable = lib.mkEnableOption "Enables bat.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.bat.package;
      description = "The bat package to use.";
    };
  };

  config = lib.mkIf config.terminal.bat.enable {
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
