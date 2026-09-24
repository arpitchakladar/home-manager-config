# Font configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fonts;
in
{
  options.fonts = {
    normal = lib.mkOption {
      type = lib.types.str;
      description = "Default normal font name.";
    };

    bold = lib.mkOption {
      type = lib.types.str;
      description = "Default bold font name.";
      default = cfg.normal;
    };

    italic = lib.mkOption {
      type = lib.types.str;
      description = "Default italic font name.";
      default = cfg.normal;
    };

    size = lib.mkOption {
      type = lib.types.int;
      description = "Default font size.";
      default = 18;
    };

    ui-size = lib.mkOption {
      type = lib.types.int;
      description = "Default desktop UI (GTK) font size.";
      default = 11;
    };

    icon-size = lib.mkOption {
      type = lib.types.int;
      description = "Font size for icons (base size + 6).";
      default = 24;
    };

    label-size = lib.mkOption {
      type = lib.types.int;
      description = "Font size for labels (base size - 2).";
      default = 16;
    };

    small-size = lib.mkOption {
      type = lib.types.int;
      description = "Font size for small text (base size - 6).";
      default = 12;
    };

    idx-size = lib.mkOption {
      type = lib.types.int;
      description = "Font size for index numbers (base size - 4).";
      default = 14;
    };
  };

  config = {
    fonts.normal = lib.mkDefault "Hack Nerd Font";

    home.packages = [
      pkgs.nerd-fonts.hack
    ];
  };
}
