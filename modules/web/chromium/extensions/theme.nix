{
  extLib,
  ...
}:
let
  pname = "theme";
in
{
  inherit pname;
  version = "1.0.0";
  id = null;
  drv = extLib.mkLocalExtension {
    inherit pname;
    srcDir = ./theme;
  };
}
