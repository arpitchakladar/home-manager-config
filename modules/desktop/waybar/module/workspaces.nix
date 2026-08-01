{
  config,
  lib,
  icons,
  ...
}:
{
  format = "{windows} <span rise='-3000' font_size='small'>{id}</span>";
  persistent-workspaces = {
    "*" = [
      1
      2
      3
      4
      5
      6
      7
      8
      9
      10
    ];
  };
  window-rewrite-default = icons."Default";
  window-rewrite = {
    "class<chromium-browser>" = lib.mkIf config.web.chromium.enable icons."Chromium";
    "class<kitty>" = lib.mkIf config.terminal.kitty.enable icons."Kitty";
    "class<vlc>" = lib.mkIf config.media.vlc.enable icons."VLC";
    "class<org.pwmt.zathura>" = lib.mkIf config.office.zathura.enable icons."Zathura";
    "class<heroic>" = lib.mkIf config.gaming.heroic.enable icons."Heroic";
    "class<Steam>" = lib.mkIf config.gaming.steam.enable icons."Steam";
    "class<bruno>" = lib.mkIf config.development.bruno.enable icons."Bruno";
    "class<codium>" = lib.mkIf config.development.vscodium.enable icons."VSCodium";

    "title<Virtual Machine Manager>" = lib.mkIf config.development.qemu.enable icons."VirtManager";
    "title<OC \\| (.*)>" = lib.mkIf config.development.opencode.enable icons."Opencode";
    "title<OpenCode>" = lib.mkIf config.development.opencode.enable icons."Opencode";
    "title<Swayimg:(.*)>" = lib.mkIf config.media.swayimg.enable icons."Swayimg";
    "title<Yazi:(.*)>" = lib.mkIf config.file-management.yazi.enable icons."Yazi";
    "title<bluetui>" = lib.mkIf config.networking.bluetui.enable icons."bluetui";
    "title<impala>" = lib.mkIf config.networking.impala.enable icons."impala";
    "title<neomutt>" = lib.mkIf config.communication.neomutt.enable icons."neomutt";
    "title<screen-recording>" =
      lib.mkIf config.scripts.screen-recording.enable
        icons."screen-recording";
    "title<system-monitor>" = lib.mkIf config.scripts.system-monitor.enable icons."system-monitor";
    "title<nvim(.*)>" = lib.mkIf config.development.nixvim.enable icons."neovim";
  };
}
