{
  lib,
  pkgs,
  config,
  checkForUpdates ? true,
}:
let
  # Fetch using the Releases API (Finds the latest official GitHub Release)
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

  # Fetch using the Tags API (Finds the newest tag matching a prefix/regex)
  fetchLatestGithubTag =
    {
      owner,
      repo,
      tagPrefix ? "",
      tagRegex ? null,
    }:
    let
      raw = builtins.fetchurl {
        url = "https://api.github.com/repos/${owner}/${repo}/tags";
        name = "${repo}-tags.json";
      };
      tags = builtins.fromJSON (builtins.readFile raw);

      isValidTag =
        t:
        let
          matchesPrefix = tagPrefix == "" || lib.hasPrefix tagPrefix t.name;
          matchesRegex = tagRegex == null || builtins.match tagRegex t.name != null;
        in
        matchesPrefix && matchesRegex;

      matchingTags = builtins.filter isValidTag tags;
    in
    if builtins.length matchingTags > 0 then
      (builtins.head matchingTags).name
    else
      throw "No tags found for ${owner}/${repo} matching prefix '${tagPrefix}' and regex '${toString tagRegex}'";

  # Internal helper to handle the version comparison and error message
  verifyAndThrow =
    {
      pname,
      version,
      latestTag,
      tagPrefix,
      urlTemplate,
      updateType,
    }:
    let
      latestVersion =
        if lib.hasPrefix tagPrefix latestTag then lib.removePrefix tagPrefix latestTag else latestTag;
    in
    if latestVersion != version then
      throw ''
        [${pname}] A newer ${updateType} is available upstream — refusing to build a stale extension.

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
in
{
  checkExtensionVersion =
    {
      pname,
      owner,
      repo,
      version,
      urlTemplate,
      tagPrefix ? "",
    }:
    if !checkForUpdates then
      version
    else
      let
        latestTag = fetchLatestGithubReleaseTag { inherit owner repo; };
      in
      verifyAndThrow {
        inherit
          pname
          version
          latestTag
          tagPrefix
          urlTemplate
          ;
        updateType = "release";
      };

  checkExtensionVersionByTag =
    {
      pname,
      owner,
      repo,
      version,
      urlTemplate,
      tagPrefix ? "",
      tagRegex ? null,
    }:
    if !checkForUpdates then
      version
    else
      let
        latestTag = fetchLatestGithubTag {
          inherit
            owner
            repo
            tagPrefix
            tagRegex
            ;
        };
      in
      verifyAndThrow {
        inherit
          pname
          version
          latestTag
          tagPrefix
          urlTemplate
          ;
        updateType = "tag";
      };

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
        pkgs.python3
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
            python3 ${./inject_extension_key.py} "$out/manifest.json" "${extensionKey}"
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
