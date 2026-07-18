{ config, ... }:
[
  {
    assertion = !config.scripts.file-preview-clean.enable || config.scripts.file-preview.enable;
    message = "scripts.file-preview-clean is enabled but requires `scripts.file-preview.enable`.";
  }
]
