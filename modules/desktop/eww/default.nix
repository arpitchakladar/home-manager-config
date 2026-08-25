{
  config,
  lib,
  ...
}:
{
  imports = [
    ./yuck.nix
  ];

  options.desktop.eww = {
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.eww.package;
      description = "The eww package to use.";
    };
  };

  config = {
    programs.eww = {
      enable = true;
      systemd.enable = true;
      scssConfig = builtins.readFile (import ./scss.nix { inherit config; });
    };
  };
}
