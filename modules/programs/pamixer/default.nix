{
  config,
  lib,
  pkgs,
  ...
}:

# Pamixer - PulseAudio command-line mixer (volume control)
{
  options.programs.pamixer = {
    enable = lib.mkEnableOption "Enables pamixer.";
  };

  config = lib.mkIf config.programs.pamixer.enable {
    home.packages = with pkgs; [
      pamixer
    ];
  };
}
