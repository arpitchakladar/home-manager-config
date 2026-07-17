# Lazygit - A simple terminal UI for git commands
{ config, lib, ... }:
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
          theme = with config.scheme.withHashtag; {
            lightTheme = false;
            activeBorderColor = [
              base0D
              "bold"
            ];
            inactiveBorderColor = [ base03 ];
            optionsTextColor = [ base0D ];
            selectedLineBgColor = [ base01 ];
            selectedRangeBgColor = [ base01 ];
            cherryPickedCommitBgColor = [ base0C ];
            cherryPickedCommitFgColor = [ base0D ];
            markedBaseCommitBgColor = [ base0A ];
            markedBaseCommitFgColor = [ base0D ];
            unstagedChangesColor = [ base08 ];
            defaultFgColor = [ base05 ];
            searchingActiveBorderColor = [
              base0A
              "bold"
            ];
          };
          authorColors = {
            "*" = (with config.scheme.withHashtag; base0E);
          };
          branchColors = {
            "master" = (with config.scheme.withHashtag; base08);
            "main" = (with config.scheme.withHashtag; base08);
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
