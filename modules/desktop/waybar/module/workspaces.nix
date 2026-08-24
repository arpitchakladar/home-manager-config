{
  config,
  lib,
  icons,
  ...
}:
{
  format = "<span rise='-3000' font_size='small'>{value}</span>";
  # window-rewrite-default = icons."Default";
  # window-rewrite = {
  #   "app_id<chromium-browser>" = lib.mkIf config.web.chromium.enable icons."Chromium";
  #   "app_id<kitty>" = lib.mkIf config.terminal.kitty.enable icons."Kitty";
  #   "app_id<vlc>" = lib.mkIf config.media.vlc.enable icons."VLC";
  #   "app_id<org.pwmt.zathura>" = lib.mkIf config.office.zathura.enable icons."Zathura";
  #   "app_id<heroic>" = lib.mkIf config.gaming.heroic.enable icons."Heroic";
  #   "app_id<Steam>" = lib.mkIf config.gaming.steam.enable icons."Steam";
  #   "app_id<bruno>" = lib.mkIf config.development.bruno.enable icons."Bruno";
  #   "app_id<codium>" = lib.mkIf config.development.vscodium.enable icons."VSCodium";
  #
  #   "title<Virtual Machine Manager>" = lib.mkIf config.development.qemu.enable icons."VirtManager";
  #   "title<OC \\| (.*)>" = lib.mkIf config.development.opencode.enable icons."Opencode";
  #   "title<OpenCode>" = lib.mkIf config.development.opencode.enable icons."Opencode";
  #   "title<Swayimg:(.*)>" = lib.mkIf config.media.swayimg.enable icons."Swayimg";
  #   "title<Yazi:(.*)>" = lib.mkIf config.file-management.yazi.enable icons."Yazi";
  #   "title<bluetui>" = lib.mkIf config.networking.bluetui.enable icons."bluetui";
  #   "title<impala>" = lib.mkIf config.networking.impala.enable icons."impala";
  #   "title<neomutt>" = lib.mkIf config.communication.neomutt.enable icons."neomutt";
  #   "title<screen-recording>" =
  #     lib.mkIf config.scripts.screen-recording.enable
  #       icons."screen-recording";
  #   "title<system-monitor>" = lib.mkIf config.scripts.system-monitor.enable icons."system-monitor";
  #   "title<nvim(.*)>" = lib.mkIf config.development.nixvim.enable icons."neovim";
  #   "title<gopass>" = lib.mkIf config.development.nixvim.enable icons."gopass";
  # };
}
