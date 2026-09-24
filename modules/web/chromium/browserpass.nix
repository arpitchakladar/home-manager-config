{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.web.chromium;

  # Extension ID computed from the pinned extensionKey
  patchedHost =
    pkgs.runCommand "com.github.browserpass.native.json"
      {
        nativeBuildInputs = [
          (pkgs.luajit.withPackages (ps: [ ps.dkjson ]))
        ];
      }
      ''
        luajit ${./patch_native_host.lua} \
          ${cfg.extensions.browserpass.id} \
          ${config.programs.browserpass.package}/lib/browserpass/hosts/chromium/com.github.browserpass.native.json \
          $out
      '';
in
{
  config = lib.mkIf (cfg.enable && config.security.gopass.enable) {
    programs.browserpass = {
      enable = true;
      browsers = [ "chromium" ];
    };
    home.file.".config/chromium/NativeMessagingHosts/com.github.browserpass.native.json" = lib.mkForce {
      source = patchedHost;
    };
  };
}
