{ config, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "arpit";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.05";

  # Desktop environment
  desktop.enable = true;

  # Tools
  programs.aria2.enable = true;
  programs.bat.enable = true;
  programs.bluetui.enable = true;
  programs.bottom.enable = true;
  programs.brave.enable = true;
  programs.brightnessctl.enable = true;
  programs.bruno.enable = true;
  programs.email.enable = true;
  programs.enteauth.enable = true;
  programs.feh.enable = true;
  programs.ffmpeg.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;
  programs.git.username = "Arpit Chakladar";
  programs.git.email = "arpitchakladar+git@gmail.com";
  programs.git.useSSH = true;
  programs.git.signing.signByDefault = true;
  programs.gpg.enable = true;
  programs.heroic.enable = true;
  programs.htop.enable = true;
  programs.impala.enable = true;
  programs.kitty.enable = true;
  programs.less.enable = true;
  programs.lf.enable = true;
  programs.lsd.enable = true;
  programs.maim.enable = true;
  programs.meli.enable = true;
  programs.nixvim.enable = true;
  programs.nvtop.enable = true;
  programs.opencode.enable = true;
  programs.ssh.enable = true;
  programs.openvpn.enable = true;
  programs.ouch.enable = true;
  programs.pamixer.enable = true;
  programs.gopass.enable = true;
  programs.playerctl.enable = true;
  programs.qemu.enable = true;
  programs.slop.enable = true;
  programs.starship.enable = true;
  programs.systemctl-tui.enable = true;
  programs.tmux.enable = true;
  programs.tor.enable = true;
  programs.vlc.enable = true;
  programs.vscodium.enable = true;
  programs.zathura.enable = true;
  programs.zsh.enable = true;

  programs.home-manager.enable = true;
}
