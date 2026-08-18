{ pkgs, lib, ... }:

let
  chromiumExtensions = (import ./web/chromium/extensions.nix { inherit pkgs lib; }).mkUpdateScript;
in
pkgs.writeShellApplication {
  name = "updates";
  runtimeInputs = [ chromiumExtensions ];
  text = ''
    echo "Running all update checks..."
    echo ""

    check-chromium-extension-updates

    echo ""
    echo "All update checks complete."
  '';
}
