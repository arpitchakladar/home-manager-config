{
  config,
  lib,
  ...
}:
{
  options.desktop.rofi = {
    enable = lib.mkEnableOption "Enables rofi launcher." // {
      default = true;
    };
    package = lib.mkOption {
      type = lib.types.package;
      description = "The rofi package to use.";
    };
  };

  config = lib.mkIf config.desktop.enable {
    desktop.rofi.package = lib.mkDefault config.programs.rofi.finalPackage;

    programs.rofi = {
      enable = config.desktop.rofi.enable;
      theme = "${config.scheme {
        template = builtins.readFile ./theme.mustache.rasi;
        extension = ".rasi";
      }}";
      extraConfig = {
        modi = "drun";
        show-icons = true;
        drun-display-format = "{name}";
        display-drun = "Launch";
        sort = true;
      };
    };
  };
}
