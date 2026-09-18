{
  pkgs,
  ...
}:

let
  extensions = import ../../../modules/web/chromium/extensions/metadata.nix;

  extensionsJsonString = builtins.replaceStrings [ "\\" "\"" ] [ "\\\\" "\\\"" ] (
    builtins.toJSON (
      map (ext: {
        pname = ext.pname;
        owner = ext.owner;
        repo = ext.repo;
        version = ext.version;
        updateType = ext.updateType or "release";
        tagPrefix = ext.tagPrefix;
      }) extensions
    )
  );

  luaEnv = pkgs.luajit.withPackages (ps: [
    ps.lua-cjson
    ps.http
  ]);

  luaScript = pkgs.writeText "check-chromium-extension-updates.lua" (
    builtins.replaceStrings [ "@@EXTENSIONS@@" ] [ extensionsJsonString ] (
      builtins.readFile ./check-chromium-extension-updates.lua
    )
  );
in
{
  mkUpdateScript = pkgs.stdenv.mkDerivation {
    pname = "check-chromium-extension-updates";
    version = "0.1.0";
    dontUnpack = true;
    nativeBuildInputs = [ luaEnv ];
    installPhase = ''
      mkdir -p $out/bin
      install -m755 ${luaScript} $out/bin/check-chromium-extension-updates
      patchShebangs $out/bin/check-chromium-extension-updates
    '';
    meta = {
      mainProgram = "check-chromium-extension-updates";
    };
  };
}
