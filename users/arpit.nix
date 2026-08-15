# User-specific home-manager configuration
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
  desktop.hardware.gpu = {
    nvidia.enable = true;
    amd.enable = true;
    primaryCard = "/dev/dri/gpu-amd";
    secondaryCard = "/dev/dri/gpu-nvidia";
  };

  # Gaming
  gaming.heroic.enable = true;
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
  file-management.eza.enable = true;
  file-management.ouch.enable = true;
  file-management.usb.enable = true;
  file-management.yazi.enable = true;

  # Media
  media.swayimg.enable = true;
  media.grim.enable = true;
  media.pamixer.enable = true;
  media.playerctl.enable = true;
  media.slurp.enable = true;
  media.vlc.enable = true;
  media.wf-recorder.enable = true;

  # Networking
  networking.impala.enable = true;
  networking.bluetui.enable = true;
  networking.usque.enable = true;

  # Office
  office.zathura.enable = true;

  # Security
  security.gopass.enable = true;
  security.gopass.ssh-agent.enable = true;
  security.gpg.enable = true;
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
  web.chromium.enable = true;
  web.chawan.enable = true;

  development.git.signing.signByDefault = true;

  programs.home-manager.enable = true;
}
