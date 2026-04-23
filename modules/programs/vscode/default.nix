{
  config,
  lib,
  pkgs,
  ...
}:

# VSCode - Visual Studio Code (using VSCodium open-source build)
{
  config = lib.mkIf config.programs.vscode.enable {
    programs.vscode = {
      package = pkgs.vscodium;
    };
  };
}
