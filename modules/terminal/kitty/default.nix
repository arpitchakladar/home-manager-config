# GPU-accelerated terminal emulator
{
  config,
  lib,
  ...
}:
{
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
      extraConfig = ''
        # Keep normal clicks for selection and prompt placement; Ctrl+click opens links.
        mouse_map left click ungrabbed mouse_handle_click selection prompt
        mouse_map ctrl+left click grabbed,ungrabbed mouse_handle_click link

        # Vim-style navigation between Kitty windows in the current tab.
        map ctrl+shift+h neighboring_window left
        map ctrl+shift+j neighboring_window bottom
        map ctrl+shift+k neighboring_window top
        map ctrl+shift+l neighboring_window right
      '';
      settings = with config.scheme.withHashtag; {
        window_padding_width = 10;
        font_size = config.fonts.size;
        font_family = config.fonts.normal;
        filter_notification = "all";
        update_check_interval = 0;
        scrollbar_indicator_opacity = "0.5";

        dynamic_background_opacity = false;
        enable_audio_bell = false;

        background = base00;
        foreground = base05;

        color0 = base00;
        color1 = base08;
        color2 = base0B;
        color3 = base0A;
        color4 = base0D;
        color5 = base0E;
        color6 = base0C;
        color7 = base05;
        color8 = base03;
        color9 = base09;
        color10 = base0B;
        color11 = base0A;
        color12 = base0D;
        color13 = base0E;
        color14 = base0F;
        color15 = base07;

        selection_background = base05;
        selection_foreground = base00;

        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty";
        shell = lib.mkIf config.terminal.zsh.enable (lib.getExe config.terminal.zsh.package);
      };
    };
  };
}
