# Provide options/configurations for other modules to use base16 colorschemes
{
  config,
  lib,
  pkgs,
  ...
}:
let
  schemeFiles = {
    "onedark-dark" = ./onedark-dark.nix;
  };

  schemeFile =
    schemeFiles.${config.colors.base16} or (throw "Unknown color scheme: ${config.colors.base16}");

  colors = import schemeFile { };

  withHashtag = lib.mapAttrs (_: v: "#${v}") colors;
  colorNames = builtins.attrNames colors;

  processTemplate =
    template:
    let
      content = if builtins.typeOf template == "path" then builtins.readFile template else template;
      replaced = builtins.replaceStrings (map (name: "@@${name}@@") colorNames) (map (
        name: colors.${name}
      ) colorNames) content;
    in
    replaced;
in
{
  options = {
    colors.base16 = lib.mkOption {
      type = lib.types.str;
      default = "onedark-dark";
      description = "Base16 color scheme to use";
    };

    scheme = lib.mkOption {
      type = lib.types.unspecified;
      description = "Color scheme providing withHashtag and template function";
    };
  };

  config = {
    scheme = {
      inherit withHashtag;
      __functor =
        self:
        {
          template,
          extension ? "",
        }:
        pkgs.writeText "themed${extension}" (processTemplate template);
    };
  };
}
