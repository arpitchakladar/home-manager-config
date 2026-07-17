# Modules - Top-level module aggregator importing all submodules
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
    ./networking
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
