{ icons, ... }:
{
  expand = true;
  format = "{}";
  rewrite = {
    "(.*) - Chromium" = "${icons."Chromium"} $1";
    "(.*?)(?: - )?VLC Media Player" = "${icons."VLC"} $1";
    "(.*)heroic(.*)" = "${icons."Heroic"} $1$2";
    "(.*)Steam(.*)" = "${icons."Steam"} $1$2";
    "bruno" = "${icons."Bruno"} Bruno";
    "(.*) - VSCodium" = "${icons."VSCodium"}  $1";
    "Virtual Machine Manager" = "${icons."VirtManager"} Virtual Machine Manager";
    "OC \\|(.*)" = "${icons."Opencode"} $1";
    "OpenCode" = "${icons."Opencode"}  OpenCode";
    "Yazi:(.*)" = "${icons."Yazi"} $1";
    "Swayimg:(.*)" = "${icons."Swayimg"} $1";
    "bluetui" = "${icons."bluetui"} bluetui";
    "impala" = "${icons."impala"} impala";
    "neomutt" = "${icons."neomutt"} NeoMutt";
    "screen-recording" = "${icons."screen-recording"} Screen Recording";
    "system-monitor" = "${icons."system-monitor"} System Monitor";
    "nvim(.*)" = "${icons."neovim"} $1";
  };
}
