# GNU Bourne Again SHell
{ lib, ... }:
{
  options.terminal.bash = {
    enable = lib.mkEnableOption "Enables bash.";
  };
}
