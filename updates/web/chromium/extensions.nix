{
  pkgs,
  lib,
  ...
}:

let
  extensions = import ../../../modules/web/chromium/extensions/metadata.nix;

  luaExtensionList = lib.concatMapStringsSep "\n" (ext: ''
    { pname = "${ext.pname}", owner = "${ext.owner}", repo = "${ext.repo}", version = "${ext.version}", updateType = "${ext.updateType or "release"}", tagPrefix = "${ext.tagPrefix}" },
  '') extensions;

  luaScript = pkgs.writeText "check-chromium-extension-updates.lua" (
    builtins.replaceStrings [ "--@@EXTENSIONS@@--" ] [ luaExtensionList ] (
      builtins.readFile ./check-chromium-extension-updates.lua
    )
  );
in
{
  mkUpdateScript = pkgs.stdenv.mkDerivation {
    pname = "check-chromium-extension-updates";
    version = "0.1.0";
    dontUnpack = true;
    nativeBuildInputs = [
      pkgs.luajit
      pkgs.makeWrapper
    ];
    installPhase = ''
      mkdir -p $out/bin
      install -m755 ${luaScript} $out/bin/check-chromium-extension-updates
      patchShebangs $out/bin/check-chromium-extension-updates
      wrapProgram $out/bin/check-chromium-extension-updates \
        --prefix PATH : "${
          lib.makeBinPath [
            pkgs.curl
            pkgs.jq
          ]
        }"
    '';
    meta = {
      mainProgram = "check-chromium-extension-updates";
    };
  };
}
