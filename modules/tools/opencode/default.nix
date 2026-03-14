{
  config,
  lib,
  ...
}:

{
  options.tools.opencode = {
    enable = lib.mkEnableOption "Enables opencode.";
  };

  config = lib.mkIf config.tools.opencode.enable {
    programs.opencode = {
      enable = true;
    };
  };
}
