# neomutt - Terminal email client
{
  config,
  lib,
  ...
}:

{
  imports = [
    ./assertions.nix
    ./theme.nix
  ];

  config = lib.mkIf config.programs.neomutt.enable {
    programs.neomutt = {
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = true;
      unmailboxes = true;
      binds = [
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
          map = [
            "index"
            "pager"
          ];
          key = "\\CO";
          action = "sidebar-open";
        }
      ];

      macros = [
        {
          map = [
            "index"
            "pager"
          ];
          key = "O";
          action = "<sync-mailbox><shell-escape>mbsync -a<enter><sync-mailbox>";
        }
      ];
    };
  };
}
