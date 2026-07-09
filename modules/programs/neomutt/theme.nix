{ config, lib, ... }:

# Colorscheme - True base16 OneDark colors for neomutt
# Leverages Kitty's precise mapping to base16 (color0-15)
{
  config.programs.neomutt.extraConfig = lib.mkIf config.programs.neomutt.enable ''
    # vim: filetype=muttrc
    #
    # Base16 OneDark Dark terminal colors for neomutt
    # Each column in the index receives a distinct color to keep the UI organized.

    set index_format = "%4C│ %Z │ %{%d/%m %H:%M} │ %-25.25a │ %s"

    # --- Basic UI Colors --------------------------------------------------
    # fg              bg
    color normal      white         default     # base05 (Standard text)
    color error       red           default     # base08 (Red)
    color tilde       brightblack   default     # base03 (Dark Grey)
    color message     cyan          default     # base0C (Cyan)
    color markers     red           default     # base08 (Red)
    color attachment  magenta       default     # base0E (Magenta)
    color search      magenta       default     # base0E (Magenta)

    # Selected row and status bar
    color status      white         brightblack # base05 on base03
    color indicator   black         blue        # base00 on base0D (Selected email)
    color tree        brightblack   default     # base03 (Thread arrows)

    # --- Index Columns (The Multi-Color Table) ----------------------------
    # Applies distinct colors to specific columns for ALL messages (~A)
    color index_number  white       default "~A"  # base05 (Fixed: was brightblack)
    color index_date    green       default "~A"  # base0B (Green)
    color index_flags   red         default "~A"  # base08 (Red)
    color index_size    cyan        default "~A"  # base0C (Cyan)
    color index_author  yellow      default "~A"  # base0A (Yellow)
    color index_subject white       default "~A"  # base05 (Standard text for Read messages)

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

    # --- Message Headers --------------------------------------------------
    color hdrdefault  cyan          default     # base0C
    color header      yellow        default "^(From|To|Cc|Bcc)" # base0A
    color header      blue          default "^(Subject)"        # base0D
    color header      brightblack   default "^(Date)"           # base03

    # --- Message Body -----------------------------------------------------
    color quoted      blue          default     # base0D
    color quoted1     cyan          default     # base0C
    color quoted2     yellow        default     # base0A
    color quoted3     red           default     # base08
    color quoted4     magenta       default     # base0E

    color signature   green         default     # base0B
    color bold        white         default     # base05
    color underline   white         default     # base05

    # URLs
    color body        blue          default "([a-z][a-z0-9+-]*://[^ ]+)"

    # PGP
    color body        green         default "(Good signature)"
    color body        red           default "(BAD signature)"
    color body        brightblack   default "^gpg: "
  '';
}
