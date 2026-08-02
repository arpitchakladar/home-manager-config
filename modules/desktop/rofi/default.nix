{
  config,
  lib,
  ...
}:
{
  options.desktop.rofi = {
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.rofi.finalPackage;
      description = "The rofi package to use.";
    };
  };

  config = lib.mkIf config.desktop.enable {
    programs.rofi = {
      enable = true;
      theme = "${config.scheme {
        template = builtins.readFile ./theme.mustache.rasi;
        extension = ".rasi";
      }}";
      extraConfig = {
        modi = "drun";
        show-icons = true;
        drun-display-format = "{name}";
        sort = true;
      };
    };
  };
}
