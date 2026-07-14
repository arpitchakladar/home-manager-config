{ config, lib, ... }:

# Lazygit - A simple terminal UI for git commands
{
  config = lib.mkIf config.programs.lazygit.enable {
    programs.lazygit = {
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      enableZshIntegration = config.programs.zsh.enable;

      settings = {
        gui = {
          theme = {
            lightTheme = false;
          };
          showIcons = true;
          scrollHeight = 2;
          nerdFontsVersion = "3";
          scrollPastBottom = true;
          mouseEvents = true;
          border = "single";
        };
        git = {
          log.showWholeGraph = true;
          branchLogCmd = "git log-graph";
        };
        update.method = "never";
      };
    };
  };
}
