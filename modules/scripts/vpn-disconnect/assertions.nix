{ config, ... }:
[
  {
    assertion = !config.scripts.vpn-disconnect.enable || config.scripts.vpn-connect.enable;
    message = "scripts.vpn-disconnect is enabled but requires `scripts.vpn-connect.enable`.";
  }
]
