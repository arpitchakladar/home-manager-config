{
  extLib,
  ...
}:
let
  meta = import ./metadata.nix;
in
{
  inherit (meta) pname version id;
  drv = extLib.fetchUnpackedExtension {
    inherit (meta)
      pname
      version
      url
      hash
      extensionKey
      ;
  };
}
