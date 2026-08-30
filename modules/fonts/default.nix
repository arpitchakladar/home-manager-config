# Font configuration
{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.fonts = {
    normal = lib.mkOption {
      type = lib.types.str;
      description = "Default normal font name.";
    };

    bold = lib.mkOption {
      type = lib.types.str;
      description = "Default bold font name.";
      default = config.fonts.normal;
    };

    italic = lib.mkOption {
      type = lib.types.str;
      description = "Default italic font name.";
      default = config.fonts.normal;
    };

    size = lib.mkOption {
      type = lib.types.int;
      description = "Default font size.";
      default = 18;
    };

    uiSize = lib.mkOption {
      type = lib.types.int;
      description = "Default desktop UI (GTK) font size.";
      default = 11;
    };

    iconSize = lib.mkOption {
      type = lib.types.int;
      description = "Font size for icons (base size + 6).";
      default = 24;
    };

    labelSize = lib.mkOption {
      type = lib.types.int;
      description = "Font size for labels (base size - 2).";
      default = 16;
    };

    smallSize = lib.mkOption {
      type = lib.types.int;
      description = "Font size for small text (base size - 6).";
      default = 12;
    };

    idxSize = lib.mkOption {
      type = lib.types.int;
      description = "Font size for index numbers (base size - 4).";
      default = 14;
    };
  };

  config = {
    fonts.normal = lib.mkDefault "Fira Code Nerd Font";

    home.packages = with pkgs; [
      nerd-fonts.fira-code
    ];
  };
}
