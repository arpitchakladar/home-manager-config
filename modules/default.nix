{ ... }:

{
  imports = [
    ./communication
    ./desktop
    ./development
    ./file-management
    ./fonts
    ./gaming
    ./media
    ./office
    ./scripts
    ./security
    ./system
    ./terminal
    ./web
  ];

  config = {
    xdg.mimeApps = {
      enable = true;
    };
  };
}
