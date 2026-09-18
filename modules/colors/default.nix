# Configuration-wide color scheme selection.
{ lib, ... }:
{
  options.colors.base16 = lib.mkOption {
    type = lib.types.str;
    default = "onedark-dark";
    description = "Name of the base16 color scheme to use.";
  };
}
