{ config, lib, ... }:

# Lazygit - A simple terminal UI for git commands
{
  options.development.lazygit = {
    enable = lib.mkEnableOption "Enables lazygit.";
  };

  config = lib.mkIf config.development.lazygit.enable {
    programs.lazygit = {
      enable = true;
      enableBashIntegration = config.terminal.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableNushellIntegration = config.programs.nushell.enable;
      enableZshIntegration = config.terminal.zsh.enable;

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
          branchLogCmd = "git log-graph-embed";
          overrideGpg = true;
        };
        update.method = "never";
      };
    };
  };
}
