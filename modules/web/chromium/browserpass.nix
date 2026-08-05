{
  lib,
  config,
  pkgs,
  ...
}:
let
  # Extension ID computed from the pinned extensionKey
  patchedHost =
    pkgs.runCommand "com.github.browserpass.native.json"
      {
        nativeBuildInputs = [ pkgs.jq ];
      }
      ''
        jq '.allowed_origins = ["chrome-extension://${config.web.chromium.extensions.browserpass.id}/"]' \
          ${config.programs.browserpass.package}/lib/browserpass/hosts/chromium/com.github.browserpass.native.json \
          > $out
      '';
in
{
  config = lib.mkIf (config.web.chromium.enable && config.security.gopass.enable) {
    programs.browserpass = {
      enable = true;
      browsers = [ "chromium" ];
    };
    home.file.".config/chromium/NativeMessagingHosts/com.github.browserpass.native.json" = lib.mkForce {
      source = patchedHost;
    };
  };
}
