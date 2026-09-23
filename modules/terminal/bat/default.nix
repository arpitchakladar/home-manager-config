# A cat clone with wings
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terminal.bat;
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
in
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

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "base16";
      };
      themes = {
        base16 = {
          src = pkgs.runCommand "bat-base16-theme" { } ''
            mkdir -p $out
            cp ${base16Colors { templateFileOrContent = ./base16.tmTheme; }} $out/base16.tmTheme
          '';
          file = "base16.tmTheme";
        };
      };
    };
  };
}
