# OneDark Dark color scheme
# Replaces base16.nix with direct string replacement
{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = {
    base00 = "000000";
    base01 = "1c1f24";
    base02 = "2c313a";
    base03 = "434852";
    base04 = "565c64";
    base05 = "abb2bf";
    base06 = "b6bdca";
    base07 = "c8ccd4";
    base08 = "ef596f";
    base09 = "d19a66";
    base0A = "e5c07b";
    base0B = "89ca78";
    base0C = "2bbac5";
    base0D = "61afef";
    base0E = "d55fde";
    base0F = "be5046";
  };

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
  options.colors.onedark-dark = {
    enable = lib.mkEnableOption "Enables the OneDark Dark color scheme.";
  };

  options.scheme = lib.mkOption {
    type = lib.types.unspecified;
    description = "Color scheme providing withHashtag and template function";
  };

  config.scheme = lib.mkIf config.colors.onedark-dark.enable {
    inherit withHashtag;
    __functor =
      self:
      {
        template,
        extension ? "",
      }:
      pkgs.writeText "themed${extension}" (processTemplate template);
  };
}
