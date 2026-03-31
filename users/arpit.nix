{ config, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "arpit";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.05";

  # Desktop environment
  desktop.enable = true;

  # Tools
  tools.bluetui.enable = true;
  tools.bottles.enable = true;
  tools.bottom.enable = true;
  tools.brightnessctl.enable = true;
  tools.bruno.enable = true;
  tools.devenv.enable = true;
  tools.fastfetch.enable = true;
  tools.feh.enable = true;
  tools.ffmpeg.enable = true;
  tools.fzf.enable = true;
  tools.git.enable = true;
  tools.git.username = "Arpit Chakladar";
  tools.git.email = "arpitchakladar@proton.me";
  tools.htop.enable = true;
  tools.impala.enable = true;
  tools.kitty.enable = true;
  tools.libreoffice.enable = true;
  tools.librewolf.enable = true;
  tools.lsd.enable = true;
  tools.maim.enable = true;
  tools.nixvim.enable = true;
  tools.nnn.enable = true;
  tools.nvtop.enable = true;
  tools.opencode.enable = true;
  tools.openssh.enable = true;
  tools.openvpn.enable = true;
  tools.pamixer.enable = true;
  tools.playerctl.enable = true;
  tools.rofi.enable = true;
  tools.slop.enable = true;
  tools.starship.enable = true;
  tools.systemctl-tui.enable = true;
  tools.tmux.enable = true;
  tools.tor-browser.enable = true;
  tools.unar.enable = true;
  tools.vlc.enable = true;
  tools.vscode.enable = true;
  tools.zathura.enable = true;
  tools.zsh.enable = true;

  programs.home-manager.enable = true;
}
