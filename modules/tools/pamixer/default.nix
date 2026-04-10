{
  config,
  lib,
  pkgs,
  ...
}:

# Pamixer - PulseAudio command-line mixer (volume control)
{
  options.tools.pamixer = {
    enable = lib.mkEnableOption "Enables pamixer.";
  };

  config = lib.mkIf config.tools.pamixer.enable {
    home.packages = with pkgs; [
      pamixer
    ];
  };
}
