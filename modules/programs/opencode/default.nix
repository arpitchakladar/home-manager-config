{
  config,
  lib,
  pkgs,
  ...
}:

# Opencode - AI-powered coding assistant (opencode.ai)
{
  config = lib.mkIf config.programs.opencode.enable {
    programs.opencode = {
      package = pkgs.opencode;
    };
  };
}
