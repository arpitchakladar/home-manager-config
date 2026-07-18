{ config, ... }:
[
  {
    assertion = !config.scripts.vpn-connect.enable || config.security.openvpn.enable;
    message = "scripts.vpn-connect is enabled but requires `security.openvpn.enable`.";
  }
  {
    assertion = !config.scripts.vpn-connect.enable || config.terminal.fzf.enable;
    message = "scripts.vpn-connect is enabled but requires `terminal.fzf.enable`.";
  }
]
