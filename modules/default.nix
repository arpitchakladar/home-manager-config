# Top-level module aggregator importing all submodules
{ ... }:
{
  imports = [
    ./colors/base16/onedark-dark.nix
    ./communication
    ./desktop
    ./development
    ./file-management
    ./fonts
    ./gaming
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
