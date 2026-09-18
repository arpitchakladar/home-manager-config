# GPU-accelerated terminal emulator
{
  config,
  lib,
  ...
}:
{
  imports = [
    ./colors.nix
    ./keybindings.nix
  ];

  options.terminal.kitty = {
    enable = lib.mkEnableOption "Enables kitty.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.kitty.package;
      description = "The kitty package to use.";
    };
  };

  config = lib.mkIf config.terminal.kitty.enable {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };

    programs.kitty = {
      enable = true;
      extraConfig = builtins.readFile ./kitty.conf;
      settings = {
        window_padding_width = 10;
        font_size = config.fonts.size;
        font_family = config.fonts.normal;
        filter_notification = "all";
        update_check_interval = 0;
        scrollbar_indicator_opacity = "0.5";
        dynamic_background_opacity = false;
        enable_audio_bell = false;
        allow_remote_control = "no";
        shell = lib.mkIf config.terminal.zsh.enable (lib.getExe config.terminal.zsh.package);
      };
    };
  };
}
