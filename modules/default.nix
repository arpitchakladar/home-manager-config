# Top-level module aggregator importing all submodules
{ config, ... }:
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
    xdg = {
      enable = true;
      mimeApps = {
        enable = true;
      };
    };
  };
}
