# w3m - Text-based web browser and pager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  w3mDesktopItem = pkgs.makeDesktopItem {
    name = "w3m";
    desktopName = "w3m";
    exec = "${lib.getExe config.terminal.kitty.package} --class w3m -e ${lib.getExe' config.web.w3m.package "w3m"}";
    icon = "kitty";
    categories = [ "Network" ];
    comment = "Text-based web browser";
    terminal = false;
    type = "Application";
  };
in
{
  imports = [
    ./assertions.nix
  ];

  options.web.w3m = {
    enable = lib.mkEnableOption "Enables w3m.";
    package = lib.mkOption {
      type = lib.types.package;
      default = config.programs.w3m.finalPackage;
      defaultText = lib.literalExpression "config.programs.w3m.finalPackage";
      description = "Package to use for w3m. Defaults to the wrapped finalPackage from programs.w3m.";
    };
  };

  config = lib.mkIf config.web.w3m.enable {
    programs.w3m.enable = true;
    home.packages = [
      config.web.w3m.package
      w3mDesktopItem
    ];
  };
}
