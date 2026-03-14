{
  lib,
  config,
  ...
}:

{
  imports = [
    ./i3
    ./gtk
    ./polybar
  ];

  options.desktop = {
    enable = lib.mkEnableOption "Enables graphical interface.";
  };

  config = lib.mkIf config.desktop.enable {
    xdg.enable = true;
    xsession.enable = true;

    home.file.".xinitrc" = {
      text = ''
        #!/usr/bin/env sh

        [ -f ~/.Xresources ] && xrdb -merge ~/.Xresources
        [ -f ~/.profile ] && . ~/.profile
        [ -f ~/.xsession ] && . ~/.xsession

        exec ${config.xsession.windowManager.i3.package}/bin/i3
      '';
      executable = true;
    };
  };
}
