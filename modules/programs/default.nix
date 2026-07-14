{ ... }:

# Tools - Collection of tool configurations (browsers, editors, utilities, etc.)
{
  imports = [
    ./aria2
    ./bat
    ./bluetui
    ./bottom
    ./brave
    ./brightnessctl
    ./bruno
    ./delta
    ./enteauth
    ./feh
    ./ffmpeg
    ./fzf
    ./git
    ./gpg
    ./htop
    ./impala
    ./kitty
    ./lazygit
    ./less
    ./lf
    ./lsd
    ./maim
    ./neomutt
    ./nixvim
    ./nvtop
    ./opencode
    ./ssh
    ./openvpn
    ./ouch
    ./pamixer
    ./gopass
    ./email
    ./playerctl
    ./qemu
    ./slop
    ./starship
    ./systemctl-tui
    ./tmux
    ./tor
    ./vlc
    ./vscodium
    ./zathura
    ./zsh
  ];

  config = {
    xdg.mimeApps = {
      enable = true;
    };
  };
}
