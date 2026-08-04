# Keybindings - Vim-style keyboard shortcuts for neomutt
#
# Covers the core menus: generic (fallback), index, pager, sidebar,
# attach, browser, compose. Menus like pgp/smime/mix/postpone/alias/query
# are intentionally left mostly on defaults - they're rarely touched and
# not worth risking an incorrect binding for. Press `?` inside neomutt
# in any menu to see the live, authoritative list of bound functions.
{ config, lib, ... }:
{
  config.programs.neomutt.binds = lib.mkIf config.communication.neomutt.enable [
    # --- sidebar navigation (vim: Ctrl-k=up, Ctrl-j=down) ---
    {
      map = [
        "index"
        "pager"
      ];
      key = "\\Ck";
      action = "sidebar-prev";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "\\Cj";
      action = "sidebar-next";
    }
    {
      # jump into the highlighted mailbox
      map = [
        "index"
        "pager"
      ];
      key = "\\Co";
      action = "sidebar-open";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "\\Cp";
      action = "sidebar-prev-new";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "\\Cn";
      action = "sidebar-next-new";
    }
    {
      # show/hide the sidebar column entirely
      map = [
        "index"
        "pager"
      ];
      key = "B";
      action = "sidebar-toggle-visible";
    }

    # --- basic entry navigation (generic = fallback for every list-style menu) ---
    {
      map = [ "generic" ];
      key = "j";
      action = "next-entry";
    }
    {
      map = [ "generic" ];
      key = "k";
      action = "previous-entry";
    }
    {
      map = [ "generic" ];
      key = "gg";
      action = "first-entry";
    }
    {
      map = [
        "index"
        "generic"
      ];
      key = "G";
      action = "last-entry";
    }

    # --- scroll-to-position, straight from vim (zt/zz/zb) ---
    {
      map = [ "generic" ];
      key = "zt";
      action = "current-top";
    }
    {
      map = [ "generic" ];
      key = "zz";
      action = "current-middle";
    }
    {
      map = [ "generic" ];
      key = "zb";
      action = "current-bottom";
    }

    # --- pager scrolling ---
    {
      map = [ "pager" ];
      key = "j";
      action = "next-line";
    }
    {
      map = [ "pager" ];
      key = "k";
      action = "previous-line";
    }
    {
      map = [ "pager" ];
      key = "gg";
      action = "top";
    }
    {
      map = [ "pager" ];
      key = "G";
      action = "bottom";
    }
    {
      map = [
        "generic"
        "index"
        "pager"
      ];
      key = "\\Cd";
      action = "half-down";
    }
    {
      map = [
        "generic"
        "index"
        "pager"
      ];
      key = "\\Cu";
      action = "half-up";
    }
    {
      map = [
        "generic"
        "index"
        "pager"
      ];
      key = "\\Cf";
      action = "next-page";
    }
    {
      # NOTE: Ctrl-B is deliberately left unbound in the pager map here -
      # macros.nix claims it there for the chawan browser-view macro.
      map = [ "index" ];
      key = "\\Cb";
      action = "previous-page";
    }

    # --- h/l as "back / go into", vim left/right ---
    {
      map = [ "pager" ];
      key = "h";
      action = "exit";
    }
    {
      map = [ "pager" ];
      key = "l";
      action = "view-attachments";
    }
    {
      map = [ "index" ];
      key = "l";
      action = "display-message";
    }

    # --- search (mostly default already, restated for a complete reference) ---
    {
      map = [
        "generic"
        "index"
        "pager"
      ];
      key = "/";
      action = "search";
    }
    {
      map = [
        "generic"
        "index"
        "pager"
      ];
      key = "?";
      action = "search-reverse";
    }
    {
      map = [
        "generic"
        "index"
        "pager"
      ];
      key = "n";
      action = "search-next";
    }
    {
      map = [
        "generic"
        "index"
        "pager"
      ];
      key = "N";
      action = "search-opposite";
    }

    # --- delete / undelete, vim dd ---
    {
      map = [
        "index"
        "pager"
      ];
      key = "dd";
      action = "delete-message";
    }
    {
      map = [ "index" ];
      key = "dT";
      action = "delete-thread";
    }
    {
      map = [ "index" ];
      key = "u";
      action = "undelete-message";
    }
    {
      map = [ "index" ];
      key = "U";
      action = "undelete-thread";
    }
    {
      map = [ "attach" ];
      key = "dd";
      action = "delete-entry";
    }
    {
      map = [ "attach" ];
      key = "u";
      action = "undelete-entry";
    }

    # --- limit / filter the index, gf = filter, gF = clear filter ---
    {
      # prompts for a limit pattern; macros.nix binds gF to clear it
      map = [ "index" ];
      key = "gf";
      action = "limit";
    }

    # --- unread / new / flagged navigation ---
    {
      map = [ "index" ];
      key = "]";
      action = "next-unread";
    }
    {
      map = [ "index" ];
      key = "[";
      action = "previous-unread";
    }
    {
      map = [ "index" ];
      key = "}";
      action = "next-new";
    }
    {
      map = [ "index" ];
      key = "{";
      action = "previous-new";
    }
    {
      map = [ "index" ];
      key = "gn";
      action = "next-flagged";
    }
    {
      map = [ "index" ];
      key = "gp";
      action = "previous-flagged";
    }

    # --- attach menu ---
    {
      map = [ "attach" ];
      key = "l";
      action = "view-attach";
    }
    {
      map = [ "attach" ];
      key = "s";
      action = "save-entry";
    }
    {
      map = [ "attach" ];
      key = "p";
      action = "print-entry";
    }

    # --- browser (folder / file picker) ---
    {
      map = [ "browser" ];
      key = "j";
      action = "next-entry";
    }
    {
      map = [ "browser" ];
      key = "k";
      action = "previous-entry";
    }
    {
      map = [ "browser" ];
      key = "gg";
      action = "first-entry";
    }
    {
      map = [ "browser" ];
      key = "G";
      action = "last-entry";
    }
    {
      # neomutt has no dedicated "go up a directory" function - the ".."
      # row is a normal entry, so l/Enter on it goes up just fine
      map = [ "browser" ];
      key = "l";
      action = "select-entry";
    }
    {
      map = [ "browser" ];
      key = "\\Cd";
      action = "half-down";
    }
    {
      map = [ "browser" ];
      key = "\\Cu";
      action = "half-up";
    }

    # --- compose menu ---
    {
      map = [ "compose" ];
      key = "j";
      action = "next-entry";
    }
    {
      map = [ "compose" ];
      key = "k";
      action = "previous-entry";
    }
  ];
}
