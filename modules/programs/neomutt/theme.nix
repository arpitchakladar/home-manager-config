{ config, lib, ... }:

# Colorscheme - True base16 OneDark colors for neomutt
# Leverages Kitty's precise mapping to base16 (color0-15)
{
  config.programs.neomutt.extraConfig = lib.mkIf config.programs.neomutt.enable ''
    # vim: filetype=muttrc
    #
    # Base16 OneDark Dark terminal colors for neomutt
    # Each column in the index receives a distinct color to keep the UI organized.

    set index_format = " %5C │ %Z │ %{%d/%m/%y %H:%M} │ %-25.25a │ %s%* "

    # Hide the keybindings help bar at the top to save vertical space
    set help = no

    # Empty the status bar content
    set status_format = "  Unread: %5u  │  󰛏 New: %5n  │   Tagged: %5t   %>    Filter: %V  │   Sorted By: %s  │"

    # --- Basic UI Colors --------------------------------------------------
    #     target      foreground    background
    color normal      white         default     # base05 (Standard text)
    color error       red           default     # base08 (Red)
    color tilde       brightblack   default     # base03 (Dark Grey)
    color message     cyan          default     # base0C (Cyan)
    color markers     red           default     # base08 (Red)
    color attachment  magenta       default     # base0E (Magenta)
    color search      magenta       default     # base0E (Magenta)
    color prompt      cyan          default     # base0C (Questions/prompts)
    color progress    black         yellow      # base0A bg (Progress bar)

    # Selected row and status bar
    color status      white         brightblack # base05  on base03
    color indicator   default       brightblack # default on base03 (Selected email)
    color tree        magenta       default     # base03  (Thread arrows)

    # Whole-line fallback for the index (base for anything not caught below)
    color index       white         default     # base05

    # --- Index Columns (The Multi-Color Table) ----------------------------
    # Applies distinct colors to specific columns for ALL messages (~A)
    color index_number    cyan        default "~A"  # base05 (Fixed: was brightblack)
    color index_date      green       default "~A"  # base0B (Green)
    color index_flags     red         default "~A"  # base08 (Red)
    color index_size      cyan        default "~A"  # base0C (Cyan)
    color index_author    yellow      default "~A"  # base0A (Yellow)
    color index_subject   white       default "~A"  # base05 (Standard text for Read messages)
    color index_collapsed yellow      default        # base0A (Collapsed thread count, %M)
    color index_label     magenta     default        # base0E (Message label, %y %Y)
    color index_tag       cyan        default        # base0C (Message tags, %G)
    color index_tags      cyan        default        # base0C (Transformed tags, %g %J)

    # --- Index Message States ---------------------------------------------
    # By targeting *only* `index_subject`, we preserve your multi-color 
    # columns while still easily identifying unread or flagged emails.
    color index_subject blue        default "~U"  # Unread: Blue (base0D)
    color index_subject blue        default "~N"  # New: Blue (base0D)
    color index_subject red         default "~F"  # Flagged: Red (base08)
    color index_subject magenta     default "~Q"  # Replied: Magenta (base0E)
    color index_subject black       red     "~D"  # Deleted

    # This rule now colors the "email (name)" column as it is considered the 'author'
    color index_author  yellow      default "~A"
    color index_subject white       default "~A"  # %s

    # We removed the ~R (Read) override so it stays white. 
    # For Deleted (~D), if brightblack is still too dark to see, we can use a red background instead:
    color index_subject black       red     "~D"  # Deleted: Black on Red background

    # Thread collapsing states
    color index_subject yellow      default "~v"        # Collapsed thread
    color index_subject blue        default "~v~(~N)"   # Collapsed with unread inside
    color index_subject red         default "~v~(~F)"   # Collapsed with flagged inside

    # Subtle zebra striping between adjacent index rows (barely-there contrast)
    color stripe_odd  default default
    color stripe_even default default

    # --- Message Headers --------------------------------------------------
    color hdrdefault  cyan          default     # base0C
    color header      yellow        default "^(From|To|Cc|Bcc)" # base0A
    color header      blue          default "^(Subject)"        # base0D
    color header      green         default "^(Date)"           # base03

    # Attachment header lines (shown above each MIME part in the pager)
    color attach_headers cyan       default

    # --- Message Body -----------------------------------------------------
    color quoted      blue          default     # base0D
    color quoted1     cyan          default     # base0C
    color quoted2     yellow        default     # base0A
    color quoted3     red           default     # base08
    color quoted4     magenta       default     # base0E
    color quoted5     blue          default     # base0D (cycle repeats)
    color quoted6     cyan          default     # base0C
    color quoted7     yellow        default     # base0A
    color quoted8     red           default     # base08
    color quoted9     magenta       default     # base0E

    color signature   green         default     # base0B
    color bold        white         default     # base05
    color underline   white         default     # base05

    # URLs
    color body        blue          default "([a-z][a-z0-9+-]*://[^ ]+)"

    # PGP
    color body        green         default "(Good signature)"
    color body        red           default "(BAD signature)"
    color body        brightblack   default "^gpg: "

    # --- Sidebar (was completely unset despite sidebar.enable = true) -----
    color sidebar_background default     default     # transparent, blends with terminal bg
    color sidebar_divider    white       default    # base03 (matches old tree color)
    color sidebar_ordinary   white       default    # base05 (normal mailbox entries)
    color sidebar_new        green       default    # base0B (mailboxes with new mail)
    color sidebar_flagged    red         default    # base08 (mailboxes with flagged mail)
    color sidebar_spool_file yellow      default    # base0A (your inbox/spool)
    color sidebar_highlight  white       brightblack # base05 on base03 (cursor position)
    color sidebar_indicator  default     brightblack # default on base03 (currently open mailbox)
  '';
}
