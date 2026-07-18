{ config, ... }:
[
  {
    assertion = !config.scripts.neomutt-sync.enable || config.communication.neomutt.enable;
    message = "scripts.neomutt-sync is enabled but requires `communication.neomutt.enable`.";
  }
]
