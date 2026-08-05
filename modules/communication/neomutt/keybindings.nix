{ config, lib, ... }:

{
  config.programs.neomutt.binds = lib.mkIf config.communication.neomutt.enable (
    lib.mkMerge [
      # Force noop bindings to the top of neomuttrc
      (lib.mkBefore [
        {
          map = [
            "generic"
            "index"
            "pager"
            "browser"
            "attach"
            "compose"
          ];
          key = "z";
          action = "noop";
        }
        {
          map = [
            "generic"
            "index"
            "pager"
            "browser"
            "attach"
            "compose"
          ];
          key = "d";
          action = "noop";
        }
        {
          map = [
            "generic"
            "index"
            "pager"
            "browser"
            "attach"
            "compose"
          ];
          key = "g";
          action = "noop";
        }
      ])

      # Other bindings
      [
        # Sidebar navigation
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
          key = "\\Cn";
          action = "sidebar-toggle-visible";
        }

        # Basic movement
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

        # Scrolling
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
          map = [ "index" ];
          key = "\\Cb";
          action = "previous-page";
        }

        # Searching and limiting
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
        {
          map = [ "index" ];
          key = "gf";
          action = "limit";
        }

        # Message states and threads
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
          key = "za";
          action = "collapse-thread";
        }
        {
          map = [ "index" ];
          key = "zA";
          action = "collapse-all";
        }

        # Core email actions
        {
          map = [
            "index"
            "pager"
          ];
          key = "m";
          action = "mail";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "r";
          action = "reply";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "R";
          action = "group-reply";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "f";
          action = "forward-message";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "c";
          action = "change-folder";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "s";
          action = "save-message";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "y";
          action = "copy-message";
        }
        {
          map = [ "index" ];
          key = "t";
          action = "tag-entry";
        }
        {
          map = [ "pager" ];
          key = "t";
          action = "tag-message";
        }
        {
          map = [ "index" ];
          key = "T";
          action = "tag-thread";
        }
        {
          map = [
            "index"
            "pager"
          ];
          key = "gh";
          action = "display-toggle-weed";
        }

        # Deletion and undeletion
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
          map = [
            "index"
            "pager"
          ];
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

        # Menu specific
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
        {
          map = [ "compose" ];
          key = "y";
          action = "send-message";
        }
        {
          map = [ "compose" ];
          key = "a";
          action = "attach-file";
        }
        {
          map = [ "compose" ];
          key = "e";
          action = "edit-message";
        }
        {
          map = [ "compose" ];
          key = "p";
          action = "postpone-message";
        }

        # Global exit
        {
          map = [
            "generic"
            "index"
            "pager"
            "browser"
            "attach"
            "compose"
          ];
          key = "q";
          action = "exit";
        }
      ]
    ]
  );
}
