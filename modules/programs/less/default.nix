{ config, lib, ... }:

# less - terminal pager
{
  config = lib.mkIf config.programs.less.enable {
    programs.less = {
      options = [
        "--RAW-CONTROL-CHARS"
        "--quit-if-one-screen"
        "--no-init"
        "--ignore-case"
      ];
    };
  };
}
