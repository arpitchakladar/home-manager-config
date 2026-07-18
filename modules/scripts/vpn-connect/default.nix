{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "vpn-connect";
    path = ./script.sh;
    description = "VPN-connect - OpenVPN connection script with credential caching and monitoring";
    env = {
      SYSTEMD_RESOLVED_PATH = "${config.security.openvpn.package}/libexec/update-systemd-resolved";
    };
    deps = [
      config.terminal.fzf.package
      config.security.openvpn.package
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig // {
    assertions = base.moduleConfig.assertions ++ (import ./assertions.nix { inherit config lib; });
  };
}
