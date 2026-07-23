{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "yazi-file-chooser";
    path = ./script.sh;
    description = "Yazi-based file chooser for XDG Desktop Portal";
    deps = [
      config.file-management.yazi.package
      config.terminal.kitty.package
    ];
    extraLinks = [ "~/.config/xdg-desktop-portal-termfilechooser/config" ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig;
}
