{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.desktop.enable {
    services.xremap = {
      enable = true;
      withX11 = true;
      config.keymap = [
        {
          name = "Global Shortcuts";
          remap = lib.mkMerge [
            # (import ./keybindings/brightnessctl.nix { inherit pkgs; })
            (import ./keybindings/bspwm.nix { inherit pkgs; })
            (import ./keybindings/kitty.nix { inherit pkgs; })
            (import ./keybindings/maim.nix { inherit pkgs; })
            # (import ./keybindings/pamixer.nix { inherit pkgs; })
            # (import ./keybindings/playerctl.nix { inherit pkgs; })
            (import ./keybindings/rofi.nix { inherit pkgs; })
          ];
        }
      ];
    };
  };
}
