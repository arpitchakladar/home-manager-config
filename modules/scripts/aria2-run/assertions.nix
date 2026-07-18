{ config, ... }:
[
  {
    assertion = !config.scripts.aria2-run.enable || config.web.aria2.enable;
    message = "scripts.aria2-run is enabled but requires `web.aria2.enable`.";
  }
]
