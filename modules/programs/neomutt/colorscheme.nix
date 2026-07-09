{ config, lib, ... }:

# Colorscheme - True base16 colors for neomutt
# Uses standard terminal ANSI color names that kitty maps to the base16 onedark-dark scheme
# Matching the base16 colorscheme used by neovim and other tools
{
  config.programs.neomutt.extraConfig = lib.mkIf config.programs.neomutt.enable ''
    # vim: filetype=muttrc
    #
    # base16 terminal colors for neomutt
    # ANSI terminal colors are mapped by kitty to base16 onedark-dark
    # Matching the base16 colorscheme used by neovim, bat, and other tools
    #

    # basic colors ---------------------------------------------------------
    # fg (baseXX)         bg (baseXX)
    color normal        white           default         # base05 on base00
    color error         red             default         # base08 on base00
    color tilde         brightblack     default         # base03 on base00
    color message       blue            default         # base0D on base00
    color markers       red             default         # base08 on base00
    color attachment    white           default         # base05 on base00
    color search        magenta         default         # base0E on base00
    color status        brightblue      black           # base04 on base01
    color indicator     white           brightcyan      # base05 on base02
    color tree          yellow          default         # base0A on base00

    # basic monocolor screen
    mono  bold          bold
    mono  underline     underline
    mono  indicator     reverse
    mono  error         bold

    # index ----------------------------------------------------------------
    color index         white           default         "~A"                        # all messages
    color index         red             default         "~E"                        # expired messages
    color index         blue            default         "~N"                        # new messages
    color index         blue            default         "~O"                        # old messages
    color index         magenta         default         "~Q"                        # replied messages
    color index         green           default         "~R"                        # read messages
    color index         blue            default         "~U"                        # unread messages
    color index         blue            default         "~U~$"                      # unread, unreferenced
    color index         yellow          default         "~v"                        # collapsed thread
    color index         yellow          default         "~P"                        # messages from me
    color index         cyan            default         "~p!~F"                     # messages to me
    color index         cyan            default         "~N~p!~F"                   # new messages to me
    color index         cyan            default         "~U~p!~F"                   # unread messages to me
    color index         green           default         "~R~p!~F"                   # read messages to me
    color index         red             default         "~F"                        # flagged messages
    color index         red             default         "~F~p"                      # flagged messages to me
    color index         red             default         "~N~F"                      # new flagged messages
    color index         red             default         "~N~F~p"                    # new flagged messages to me
    color index         red             default         "~U~F~p"                    # unread flagged messages to me
    color index         black           red             "~D"                        # deleted messages
    color index         cyan            default         "~v~(!~N)"                  # collapsed thread, no unread
    color index         yellow          default         "~v~(~N)"                   # collapsed thread, some unread
    color index         green           default         "~N~v~(~N)"                 # collapsed thread, unread parent
    color index         red             black           "~v~(~F)!~N"                # collapsed thread, flagged no unread
    color index         yellow          black           "~v~(~F~N)"                 # collapsed thread, flagged & unread
    color index         green           black           "~N~v~(~F~N)"               # collapsed thread, unread parent & flagged
    color index         green           black           "~N~v~(~F)"                 # collapsed thread, unread parent & flagged
    color index         cyan            black           "~v~(~p)"                   # collapsed thread, messages to me
    color index         yellow          red             "~v~(~D)"                   # collapsed thread, deleted

    # message headers ------------------------------------------------------
    color hdrdefault    blue            default         # base0D
    color header        yellow          default         "^(From)"                   # base0A
    color header        blue            default         "^(Subject)"                # base0D

    # body -----------------------------------------------------------------
    color quoted        blue            default         # base0D
    color quoted1       cyan            default         # base0C
    color quoted2       yellow          default         # base0A
    color quoted3       red             default         # base08
    color quoted4       magenta         default         # base0E

    color signature     green           default         # base0B
    color bold          white           default         # base05
    color underline     white           default         # base05
    color normal        default         default

    color body          cyan            default         "[;:][-o][)/(|]"            # emoticons
    color body          cyan            default         "[;:][)(|]"                 # emoticons
    color body          cyan            default         "[*]?((N)?ACK|CU|LOL|SCNR|BRB|BTW|CWYL|\
                                                        |FWIW|vbg|GD&R|HTH|HTHBE|IMHO|IMNSHO|\
                                                        |IRL|RTFM|ROTFL|ROFL|YMMV)[*]?"
    color body          cyan            default         "[ ][*][^*]*[*][ ]?"         # more emoticon
    color body          cyan            default         "[ ]?[*][^*]*[*][ ]"         # more emoticon

    ## pgp
    color body          red             default         "(BAD signature)"
    color body          green           default         "(Good signature)"
    color body          brightblack     default         "^gpg: Good signature .*"
    color body          yellow          default         "^gpg: "
    color body          yellow          red             "^gpg: BAD signature from.*"
    mono  body          bold                            "^gpg: Good signature"
    mono  body          bold                            "^gpg: BAD signature from.*"

    # URL regex
    color body          brightred       default         "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"
  '';
}
