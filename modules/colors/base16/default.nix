# Shared base16 color scheme helpers. Not a module — pass the module arguments
# to it (`import <path> { inherit config lib pkgs; }`) to get
# `colorsWithHashPrefix` and a functor that renders a color template into a Nix
# store file.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  availableColorSchemeFiles = {
    "onedark-dark" = ./onedark-dark.nix;
  };

  selectedColorSchemeFile =
    availableColorSchemeFiles.${config.colors.base16}
      or (throw "Unknown color scheme: ${config.colors.base16}");

  selectedColorScheme = import selectedColorSchemeFile { };
  selectedColorSchemeColorNames = builtins.attrNames selectedColorScheme;

  renderColorSchemeTemplate =
    templateFileOrContent:
    let
      templateContent =
        if builtins.typeOf templateFileOrContent == "path" then
          builtins.readFile templateFileOrContent
        else
          templateFileOrContent;
    in
    builtins.replaceStrings (map (colorName: "@@${colorName}@@") selectedColorSchemeColorNames) (map (
      colorName: selectedColorScheme.${colorName}
    ) selectedColorSchemeColorNames) templateContent;
in
{
  colorsWithHashPrefix = lib.mapAttrs (_colorName: colorValue: "#${colorValue}") selectedColorScheme;

  __functor =
    _self:
    {
      templateFileOrContent,
      fileExtension ? "",
    }:
    pkgs.writeText "color-scheme-themed${fileExtension}" (
      renderColorSchemeTemplate templateFileOrContent
    );
}
