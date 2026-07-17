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
            activeBorderColor = [
              "blue"
              "bold"
            ];
            inactiveBorderColor = [ "brightblack" ];
            optionsTextColor = [ "blue" ];
            selectedLineBgColor = [ "black" ];
            selectedRangeBgColor = [ "black" ];
            cherryPickedCommitBgColor = [ "cyan" ];
            cherryPickedCommitFgColor = [ "blue" ];
            markedBaseCommitBgColor = [ "yellow" ];
            markedBaseCommitFgColor = [ "blue" ];
            unstagedChangesColor = [ "red" ];
            defaultFgColor = [ "white" ];
            searchingActiveBorderColor = [
              "yellow"
              "bold"
            ];
          };
          authorColors = {
            "*" = "magenta";
          };
          branchColors = {
            "master" = "red";
            "main" = "red";
          };
          showIcons = true;
          scrollHeight = 2;
          nerdFontsVersion = "3";
          scrollPastBottom = true;
          mouseEvents = true;
          border = "single";
          commitHashLength = 4;
          showBranchCommitHash = true;
          showDivergenceFromBaseBranch = "arrowAndNumber";
          autoFetch = false;
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
