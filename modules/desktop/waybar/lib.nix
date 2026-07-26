{ ... }:
let
  mkIcon = color: icon: "<span foreground='${color}' font_size='120%'>${icon}</span>";
  icons = {
    "Chromium" = mkIcon "#4285F4" "";
    "Kitty" = mkIcon "#F5A97F" "󰄛";
    "VLC" = mkIcon "#FF8800" "󰕼";
    "Swayimg" = mkIcon "#7EC699" "󰋩";
    "Zathura" = mkIcon "#E06C75" "";
    "Heroic" = mkIcon "#4B93FF" "󱎓";
    "Steam" = mkIcon "#1B2838" "󰓓";
    "Bruno" = mkIcon "#F97316" "󰩃";
    "VSCodium" = mkIcon "#3993EE" "";
    "VirtManager" = mkIcon "#AD8AFF" "󰟀";
    "Opencode" = mkIcon "#98C379" "󰘦";
    "EnteAuth" = mkIcon "#E5C07B" "󰍀";
    "Yazi" = mkIcon "#56B6C2" "󰉋";
    "W3M" = mkIcon "#8BE9FD" "󰖟";
    "bluetui" = mkIcon "#BD93F9" "";
    "impala" = mkIcon "#50FA7B" "󰤢";
    "neomutt" = mkIcon "#FFB86C" "󰇮";
    "Rofi" = mkIcon "#BD93F9" "";
    "Aria2" = mkIcon "#8BE9FD" "";
    "screen-recording" = mkIcon "#FF5555" "";
    "system-monitor" = mkIcon "#50FA7B" "󰄨";
    "neovim" = mkIcon "#005900" "";
  };
in
{
  inherit mkIcon icons;
}
