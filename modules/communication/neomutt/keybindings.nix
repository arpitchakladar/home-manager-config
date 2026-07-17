{ config, lib, ... }:

{
  config.programs.neomutt.binds = lib.mkIf config.communication.neomutt.enable [
    # --- sidebar navigation (vim: k=up, j=down) ---
    {
      map = [
        "index"
        "pager"
      ];
      key = "\\CK";
      action = "sidebar-prev";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "\\CJ";
      action = "sidebar-next";
    }
    {
      # select the highlighted mailbox directly, no Ctrl+O needed
      map = [
        "index"
        "pager"
      ];
      key = "o";
      action = "sidebar-open";
    }

    # --- open / go deeper (vim: l = right/forward) ---
    {
      map = [ "index" ];
      key = "<Return>";
      action = "display-message";
    }
    {
      map = [ "index" ];
      key = "l";
      action = "display-message";
    }
    {
      map = [ "browser" ];
      key = "<Return>";
      action = "select-entry";
    }
    {
      map = [ "browser" ];
      key = "l";
      action = "select-entry";
    }
    {
      map = [ "attach" ];
      key = "<Return>";
      action = "view-attach";
    }
    {
      map = [ "attach" ];
      key = "l";
      action = "view-attach";
    }
    {
      map = [
        "alias"
        "query"
      ];
      key = "<Return>";
      action = "select-entry";
    }

    # --- back / exit (vim: h = left/back) ---
    {
      map = [ "pager" ];
      key = "h";
      action = "exit";
    }
    {
      map = [ "browser" ];
      key = "h";
      action = "exit";
    }
    {
      map = [ "attach" ];
      key = "h";
      action = "exit";
    }
    {
      map = [ "index" ];
      key = "h";
      action = "collapse-thread";
    }

    # --- pager line scrolling (vim: j/k move by line) ---
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
      # kept from before: jump straight to the next unread message,
      # extends the h/l "back/forward" metaphor already in use
      map = [ "pager" ];
      key = "l";
      action = "next-unread";
    }

    # --- top/bottom of buffer (vim: gg/G -- NOT 0/$, which mean
    #     start/end of *line* in vim and would be a false friend here) ---
    {
      map = [ "index" ];
      key = "gg";
      action = "first-entry";
    }
    {
      map = [ "index" ];
      key = "G";
      action = "last-entry";
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
      map = [ "browser" ];
      key = "gg";
      action = "first-entry";
    }
    {
      map = [ "browser" ];
      key = "G";
      action = "last-entry";
    }

    # --- page scrolling (vim: Ctrl-f/b full page, Ctrl-d/u half page) ---
    {
      map = [ "pager" ];
      key = "\\Cf";
      action = "next-page";
    }
    {
      map = [ "pager" ];
      key = "\\Cb";
      action = "previous-page";
    }
    {
      map = [ "pager" ];
      key = "\\Cd";
      action = "half-down";
    }
    {
      map = [ "pager" ];
      key = "\\Cu";
      action = "half-up";
    }
    {
      # index has no half-page concept, so Ctrl-d/u fall back to
      # the same full-page scroll as Ctrl-f/b
      map = [ "index" ];
      key = "\\Cf";
      action = "next-page";
    }
    {
      map = [ "index" ];
      key = "\\Cb";
      action = "previous-page";
    }
    {
      map = [ "index" ];
      key = "\\Cd";
      action = "half-down";
    }
    {
      map = [ "index" ];
      key = "\\Cu";
      action = "half-up";
    }

    # --- search (vim: / forward, ? backward, n/N repeat) ---
    {
      map = [
        "index"
        "pager"
      ];
      key = "/";
      action = "search";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "?";
      action = "search-reverse";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "n";
      action = "search-next";
    }
    {
      map = [
        "index"
        "pager"
      ];
      key = "N";
      action = "search-opposite";
    }

    {
      map = [
        "index"
        "pager"
      ];
      key = "u";
      action = "undelete-message";
    }

    # --- copy (vim: yy yank -- non-destructive, unlike save-message
    #     which moves/deletes the original) ---
    {
      map = [ "index" ];
      key = "y";
      action = "noop";
    }
    {
      map = [ "index" ];
      key = "yy";
      action = "copy-message";
    }

    # --- tagging (vim: v/V visual select single/whole block) ---
    # NOTE: this overrides neomutt's default "v" (view-attachments).
    # Attachments are still reachable from the pager/index via the
    # mailcap auto-view or the attach menu, but if you want plain
    # "v" back for view-attachments, just delete these two binds.
    {
      map = [ "index" ];
      key = "v";
      action = "tag-entry";
    }
    {
      map = [ "index" ];
      key = "V";
      action = "tag-thread";
    }

    # --- mailbox switching (vim: gt = next tab) ---
    {
      map = [ "index" ];
      key = "gt";
      action = "next-unread-mailbox";
    }

    # --- filter/limit (vim: gf to 'find' or 'filter') ---
    {
      map = [ "index" ];
      key = "gf";
      action = "limit";
    }

    # --- filter/limit (vim: gf to 'find' or 'filter') ---
    {
      map = [ "index" ];
      key = "gF";
      action = "limit";
    }

    # --- help message to show functions and keybindings ---
    {
      map = [
        "index"
        "pager"
        "browser"
        "attach"
      ];
      key = "g?";
      action = "help";
    }
  ];
}
