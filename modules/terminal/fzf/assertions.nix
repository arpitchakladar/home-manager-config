# fzf shell integration is only provided for zsh. bash is scripting-only
# (not a login shell), so it does not receive fzf integration.
{ config, ... }:
let
  cfg = config.terminal.fzf;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.terminal.zsh.enable;
      message = ''
        terminal.fzf is enabled but terminal.zsh.enable is not set.
        fzf shell integration requires zsh. Please enable zsh.
      '';
    }
  ];
}
