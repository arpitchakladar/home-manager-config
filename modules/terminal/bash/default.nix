# GNU Bourne Again SHell
#
# This module is always enabled — there is no enable option.
# All modules that need bash should use `config.terminal.bash.package`
# instead of `pkgs.bash` directly.
{ lib, pkgs, ... }:
{
  options.terminal.bash = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
      defaultText = "pkgs.bash";
      description = "The bash package to use.";
    };
  };
}
