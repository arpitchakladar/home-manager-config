# less - terminal pager
{ config, lib, ... }:
{
  options.terminal.less = {
    enable = lib.mkEnableOption "Enables less.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.less.package;
      description = "The less package to use.";
    };
  };

  config = lib.mkIf config.terminal.less.enable {
    programs.less = {
      enable = true;
      options = [
        "--RAW-CONTROL-CHARS"
        "--quit-if-one-screen"
        "--no-init"
        "--ignore-case"
      ];
    };
  };
}
