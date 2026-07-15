{ config, ... }:

{
  imports = [
    ../modules/private/email.nix
    ../modules/private/git.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "arpit";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.05";

  # Desktop environment
  desktop.enable = true;

  # Gaming
  gaming.enable = true;
  gaming.steam.enable = false;

  # Communication
  communication.neomutt.enable = true;

  # Development
  development.bruno.enable = true;
  development.delta.enable = true;
  development.git.enable = true;
  development.git.useSSH = true;
  development.lazygit.enable = true;
  development.nixvim.enable = true;
  development.opencode.enable = true;
  development.qemu.enable = true;
  development.vscodium.enable = true;

  # File Management
  file-management.lf.enable = true;
  file-management.lsd.enable = true;
  file-management.ouch.enable = true;

  # Media
  media.feh.enable = true;
  media.ffmpeg.enable = true;
  media.maim.enable = true;
  media.pamixer.enable = true;
  media.playerctl.enable = true;
  media.slop.enable = true;
  media.vlc.enable = true;

  # Networking
  networking.impala.enable = true;
  networking.bluetui.enable = true;

  # Office
  office.zathura.enable = true;

  # Security
  security.enteauth.enable = true;
  security.gopass.enable = true;
  security.gpg.enable = true;
  security.openvpn.enable = true;
  security.ssh.enable = true;

  # System
  system.bottom.enable = true;
  system.brightnessctl.enable = true;
  system.htop.enable = true;
  system.nvtop.enable = true;
  system.systemctl-tui.enable = true;

  # Terminal
  terminal.bat.enable = true;
  terminal.fzf.enable = true;
  terminal.kitty.enable = true;
  terminal.less.enable = true;
  terminal.starship.enable = true;
  terminal.tmux.enable = true;
  terminal.zsh.enable = true;

  # Web
  web.aria2.enable = true;
  web.brave.enable = true;

  development.git.signing.signByDefault = true;

  programs.home-manager.enable = true;
}
