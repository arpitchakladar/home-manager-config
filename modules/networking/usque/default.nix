# Usque - Open-source reimplementation of the Cloudflare WARP client's MASQUE protocol
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.networking.usque = {
    enable = lib.mkEnableOption "Enables usque.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.usque;
      description = "The usque package to use.";
    };
  };

  config = lib.mkIf config.networking.usque.enable {
    home.packages = [ config.networking.usque.package ];
  };
}
