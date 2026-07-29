{
  lib,
  pkgs,
  config,
  checkForUpdates ? true,
}:
rec {
  # --- Hit the GitHub releases API and return the latest tag name. ---
  # Impure: requires --impure since there's no fixed output hash for the API
  # response itself. Optionally uses $GITHUB_TOKEN to dodge rate limits.
  fetchLatestGithubReleaseTag =
    { owner, repo }:
    let
      raw = builtins.fetchurl {
        url = "https://api.github.com/repos/${owner}/${repo}/releases/latest";
        name = "${repo}-latest-release.json";
      };
      json = builtins.fromJSON (builtins.readFile raw);
    in
    json.tag_name;

  # --- Compare pinned version against upstream latest, abort with instructions if stale. ---
  # Returns `version` unchanged on success so it can be threaded into the
  # derivation below and force this check to actually run.
  checkExtensionVersion =
    {
      pname,
      owner,
      repo,
      version,
      urlTemplate, # human-readable template shown in the error message
      tagPrefix ? "", # e.g. "v" if tags look like "v1.2.3"
    }:
    if !checkForUpdates then
      version
    else
      let
        latestTag = fetchLatestGithubReleaseTag { inherit owner repo; };
        latestVersion =
          if lib.hasPrefix tagPrefix latestTag then lib.removePrefix tagPrefix latestTag else latestTag;
      in
      if latestVersion != version then
        throw ''
          [${pname}] A newer release is available upstream — refusing to build a stale extension.

            pinned version : ${version}
            latest version : ${latestVersion}  (tag: ${latestTag})

          To upgrade, edit extensions/${pname}.nix:
            1. Set   version = "${latestVersion}";
            2. Point the url at the new release asset:
                 ${urlTemplate}
            3. Set   hash = lib.fakeHash;
               then re-run your switch — it'll fail with a hash mismatch showing
               the real sha256. Paste that in as the final hash.
            4. Re-run once more. This check passes once pinned == latest.

          To skip this check for now (e.g. offline / pure eval), set:
            web.chromium.checkForUpdates = false;
        ''
      else
        version;

  # --- Download + unpack a zip *or* crx into a plain unpacked-extension dir. ---
  # A CRX3 file is just: "Cr24" magic (4B) + version (4B) + header length N (4B)
  # + N bytes of protobuf header + a normal zip payload. We slice off the
  # header when isCrx = true, then unzip exactly like any other release zip —
  # so every extension, crx or not, goes through one identical pipeline.
  fetchUnpackedExtension =
    {
      pname,
      version,
      url,
      hash,
      isCrx ? false,
    }:
    pkgs.stdenv.mkDerivation {
      inherit pname version;
      src = pkgs.fetchurl { inherit url hash; };

      nativeBuildInputs = [
        config.file-management.ouch.package
      ];
      dontUnpack = true;

      buildPhase = ''
        runHook preBuild
        mkdir -p $out

        if [ "${lib.boolToString isCrx}" = "true" ]; then
          # Verify "Cr24" magic header
          magic=$(head -c 4 "$src")
          if [ "$magic" != "Cr24" ]; then
            echo "Error: $src is not a valid CRX file" >&2
            exit 1
          fi

          # Extract header length (bytes 8-11, little-endian)
          # -An (no address), -j8 (skip 8 bytes), -N4 (read 4 bytes), -tu1 (unsigned decimal 1-byte)
          bytes=$(od -An -j8 -N4 -tu1 "$src")

          # Read into individual variables and calculate the length
          read b1 b2 b3 b4 <<< $bytes
          hlen=$(( b1 + (b2 << 8) + (b3 << 16) + (b4 << 24) ))
          offset=$(( 12 + hlen ))

          dd if=$src of=payload.zip bs=1 skip=$offset status=none
          ouch decompress payload.zip --dir $out
        else
          ouch decompress $src --dir $out
        fi

        # Flatten a single wrapping folder (common in GitHub release zips)
        if [ "$(ls -1 $out | wc -l)" -eq 1 ] && [ -d "$out"/* ]; then
          shopt -s dotglob
          mv "$out"/*/* "$out"/ 2>/dev/null || true
          rmdir "$out"/*/ 2>/dev/null || true
          shopt -u dotglob
        fi

        runHook postBuild
      '';

      installPhase = "true";
    };

  # --- Package a local directory as an unpacked extension derivation. ---
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
