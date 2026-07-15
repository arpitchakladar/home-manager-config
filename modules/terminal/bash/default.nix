{ lib, ... }:

# Bash - GNU Bourne Again SHell
{
  options.terminal.bash = {
    enable = lib.mkEnableOption "Enables bash.";
  };
}
