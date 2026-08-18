{
  extLib,
  ...
}:
let
  meta = import ./metadata.nix;
in
{
  inherit (meta) pname;
  version = meta.version;
  id = null;
  drv = extLib.mkLocalExtension {
    inherit (meta) pname;
    srcDir = ./theme;
  };
}
