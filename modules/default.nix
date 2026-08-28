# Top-level module aggregator importing all submodules
{ ... }:
{
  imports = [
    ./communication
    ./desktop
    ./development
    ./file-management
    ./fonts
    ./gaming
    ./lib
    ./media
    ./networking
    ./office
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
