{ config, ... }:
{
  assertions = [
    {
      assertion =
        !config.programs.fzf.enable || config.programs.zsh.enable || config.programs.bash.enable;
      message = ''
        programs.fzf is enabled but neither programs.zsh.enable nor programs.bash.enable is set.
        fzf shell integration requires zsh or bash. Please enable at least one.
      '';
    }
  ];
}
