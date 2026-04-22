{
  pkgs,
  lib,
  config,
  ...
}:

# lf - terminal file manager
{
  options.tools.lf = {
    enable = lib.mkEnableOption "Enables lf.";
  };

  config = lib.mkIf config.tools.lf.enable {
    home.packages = with pkgs; [
      ctpv
    ];

    programs.lf = {
      enable = true;
      settings = {
        number = true;
        icons = true;
        drawbox = true;
        hidden = true;
        preview = true;
      };

      previewer = {
        source = lib.getExe' pkgs.ctpv "ctpv";
      };

      extraConfig = ''
        &${lib.getExe' pkgs.ctpv "ctpv"} -s $id
        cmd on-quit %${lib.getExe' pkgs.ctpv "ctpv"} -e $id
        set cleaner ${lib.getExe' pkgs.ctpv "ctpvclear"}
        # 1. WIPE DEFAULTS
        clearmaps

        # --- NAVIGATION ---
        map k up
        map j down
        map h updir              # Left to go out
        map l open               # Right to go in
        map g top                # nvim-tree 'g' (can also use gg)
        map G bottom
        map <c-u> half-up
        map <c-d> half-down
        map <c-b> page-up
        map <c-f> page-down

        # --- FILE MANIPULATION (Nvim-Tree Style) ---
        map a push :touch<space>    # 'a' for Add file
        map A push :mkdir<space>    # 'A' for Add directory
        map r rename                # 'r' for Rename
        map d delete                # 'd' for Delete (immediate prompt)
        map x cut                   # 'x' for Cut (Move)
        map y copy                  # 'y' for Copy
        map p paste                 # 'p' for Paste
        map c clear                 # 'c' for Clear selection/clipboard

        # --- SELECTION & VISUAL ---
        map <space> toggle          # Space to select/mark
        map v invert                # 'v' to invert selection
        map u unselect              # 'u' to unselect all
        map V visual                # 'V' for visual selection mode

        # --- SEARCH & FILTER ---
        map / search
        map ? search-back
        map n search-next
        map N search-prev
        map f find                  # 'f' like nvim-tree live filter
        map F find-back
        map ; find-next
        map , find-prev
        map . set hidden!           # Toggle hidden files (Dotfiles)

        # --- SYSTEM & UI ---
        map : read                  # ':' to enter command mode
        map $ shell                 # Shell command
        map ! shell-wait            # Shell command (Wait for key)
        map & shell-async           # Async shell command
        map R reload                # 'R' for Refresh
        map q quit                  # 'q' for Quit
        map <c-l> redraw            # Refresh screen UI

        # --- MARKS (Bookmarks) ---
        map m mark-save             # 'm' + letter to save bookmark
        map ' mark-load             # ' + letter to jump to bookmark
        map " mark-remove           # " + letter to remove bookmark
      '';
    };

    home.file.".config/lf/icons".source = ./icons;
  };
}
