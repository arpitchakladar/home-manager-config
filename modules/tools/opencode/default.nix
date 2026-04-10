{
  config,
  lib,
  ...
}:

# Opencode - AI-powered coding assistant (opencode.ai)
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
