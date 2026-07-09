{ config, ... }:

{
  # This file is a template for modules/private/default.nix
  # Copy to modules/private/default.nix and fill in your secrets.

  imports = [
    ./git.nix
    ./email.nix
  ];
}
