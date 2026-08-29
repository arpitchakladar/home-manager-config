{
  lib,
  pkgs,
  config,
}:
{
  # EXTENSION BUILDERS
  # Download and unpack a zip or crx file into an unpacked extension directory
  fetchUnpackedExtension =
    {
      pname,
      version,
      url,
      hash,
      isCrx ? false,
      extensionKey ? null,
    }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = pkgs.fetchurl { inherit url hash; };

      nativeBuildInputs = [
        config.file-management.ouch.package
        (pkgs.luajit.withPackages (ps: [ ps.dkjson ]))
      ];
      dontUnpack = true;

      buildPhase = ''
        runHook preBuild
        mkdir -p $out

        if [ "${lib.boolToString isCrx}" = "true" ]; then
          # Verify the Cr24 magic header
          magic=$(head -c 4 "$src")
          if [ "$magic" != "Cr24" ]; then
            echo "Error: $src is not a valid CRX file" >&2
            exit 1
          fi

          # Extract header length in bytes 8 to 11
          bytes=$(od -An -j8 -N4 -tu1 "$src")
          read b1 b2 b3 b4 <<< $bytes
          hlen=$(( b1 + (b2 << 8) + (b3 << 16) + (b4 << 24) ))
          offset=$(( 12 + hlen ))

          dd if=$src of=payload.zip bs=1 skip=$offset status=none
          ouch decompress payload.zip --dir $out
        else
          ouch decompress $src --dir $out
        fi

        # Flatten a single wrapping folder
        if [ "$(ls -1 $out | wc -l)" -eq 1 ] && [ -d "$out"/* ]; then
          shopt -s dotglob
          mv "$out"/*/* "$out"/ 2>/dev/null || true
          rmdir "$out"/*/ 2>/dev/null || true
          shopt -u dotglob
        fi

        # Inject the public key into manifest.json if provided
        ${lib.optionalString (extensionKey != null) ''
          if [ -f "$out/manifest.json" ]; then
            echo "Injecting extension key into manifest.json to lock the extension ID..."
            luajit ${./inject_extension_key.lua} "$out/manifest.json" "${extensionKey}"
          else
            echo "Warning: No manifest.json found in $out to inject the key!" >&2
          fi
        ''}

        runHook postBuild
      '';

      installPhase = "true";
    };

  mkLocalExtension =
    {
      pname,
      srcDir,
      version ? "1.0.0",
    }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = srcDir;
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out
        cp -r $src/* $out/
      '';
    };
}
