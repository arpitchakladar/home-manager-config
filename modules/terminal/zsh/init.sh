setopt PROMPT_SUBST

# Vi insert/command modes for command-line editing. Escape enters normal mode.
bindkey -v
KEYTIMEOUT=1

autoload -U colors && colors

export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

bindkey "^[[3~" delete-char
bindkey "^?" backward-delete-char
@@NIX_COMMAND_WRAPPERS@@
