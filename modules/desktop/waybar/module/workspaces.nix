{
  config,
  lib,
  mkIcon,
  ...
}:
let
  mkWindowRewrite =
    enable: color: icon:
    lib.mkIf enable (mkIcon color icon);
in
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
  window-rewrite-default = "";
  window-rewrite = {
    "class<chromium-browser>" = mkWindowRewrite config.web.chromium.enable "#4285F4" "";
    "class<kitty>" = mkWindowRewrite config.terminal.kitty.enable "#F5A97F" "󰄛";
    "class<vlc>" = mkWindowRewrite config.media.vlc.enable "#FF8800" "󰕼";
    "class<feh>" = mkWindowRewrite config.media.feh.enable "#7EC699" "󰋩";
    "class<org.pwmt.zathura>" = mkWindowRewrite config.office.zathura.enable "#E06C75" "";
    "class<heroic>" = mkWindowRewrite config.gaming.heroic.enable "#4B93FF" "󱎓";
    "class<Steam>" = mkWindowRewrite config.gaming.steam.enable "#1B2838" "󰓓";
    "class<bruno>" = mkWindowRewrite config.development.bruno.enable "#F97316" "󰩃";
    "class<codium>" = mkWindowRewrite config.development.vscodium.enable "#3993EE" "";
    "class<.virt-manager-wrapped>" = mkWindowRewrite config.development.qemu.enable "#AD8AFF" "󰟀";
    "class<opencode>" = mkWindowRewrite config.development.opencode.enable "#98C379" "󰘦";
    "class<io.ente.auth>" = mkWindowRewrite config.security.enteauth.enable "#E5C07B" "󰍀";
    "class<yazi>" = mkWindowRewrite config.file-management.yazi.enable "#56B6C2" "󰉋";
    "class<w3m>" = mkWindowRewrite config.web.w3m.enable "#8BE9FD" "󰖟";
    "class<bluetui>" = mkWindowRewrite config.networking.bluetui.enable "#BD93F9" "";
    "class<impala>" = mkWindowRewrite config.networking.impala.enable "#50FA7B" "󰤢";
    "class<neomutt>" = mkWindowRewrite config.communication.neomutt.enable "#FFB86C" "󰇮";
    "class<rofi>" = mkWindowRewrite config.desktop.rofi.enable "#BD93F9" "";
    "class<aria2-run>" = mkWindowRewrite config.scripts.aria2-run.enable "#8BE9FD" "";
    "class<screen-recording>" = mkWindowRewrite config.scripts.screen-recording.enable "#FF5555" "";
    "class<system-monitor>" = mkWindowRewrite config.scripts.system-monitor.enable "#50FA7B" "󰄨";
    "class<neovim>" = mkWindowRewrite config.development.nixvim.enable "#005900" "";
  };
}
