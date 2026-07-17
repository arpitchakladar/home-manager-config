# Assertions - Validates zsh or bash is enabled when fzf is enabled
{ config, ... }:
{
  assertions = [
    {
      assertion =
        !config.terminal.fzf.enable || config.terminal.zsh.enable || config.terminal.bash.enable;
      message = ''
        terminal.fzf is enabled but neither terminal.zsh.enable nor terminal.bash.enable is set.
        fzf shell integration requires zsh or bash. Please enable at least one.
      '';
    }
  ];
}
