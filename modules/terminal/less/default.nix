{ config, lib, ... }:

# less - terminal pager
{
  options.terminal.less = {
    enable = lib.mkEnableOption "Enables less.";
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
