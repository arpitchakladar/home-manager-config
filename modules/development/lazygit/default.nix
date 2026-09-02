# A simple terminal UI for git commands
{ config, lib, ... }:
{
  imports = [
    ./assertions.nix
  ];
  options.development.lazygit = {
    enable = lib.mkEnableOption "Enables lazygit.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.lazygit.package;
      description = "The lazygit package to use.";
    };
  };
  config = {
    home.file.".local/share/icons/hicolor/scalable/apps/git.svg" =
      lib.mkIf config.development.lazygit.enable
        {
          source = ../../../assets/icons/apps/git.svg;
        };

    xdg.desktopEntries."lazygit" = lib.mkIf config.development.lazygit.enable {
      name = "lazygit";
      exec = "${lib.getExe config.terminal.kitty.package} --class lazygit -e ${lib.getExe config.development.lazygit.package}";
      icon = "git";
      categories = [ "Development" ];
      comment = "A simple terminal UI for git commands";
      terminal = false;
      type = "Application";
    };

    programs.lazygit = lib.mkIf config.development.lazygit.enable {
      enable = true;
      enableBashIntegration = config.terminal.bash.enable;
      enableZshIntegration = config.terminal.zsh.enable;
      settings = {
        gui = with config.scheme.withHashtag; {
          theme = {
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
            "*" = base0E;
          };
          branchColors = {
            "master" = base08;
            "main" = base08;
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
          overrideGpg = config.security.gpg.enable;
          diffRenderers = lib.mkIf config.development.delta.enable [
            {
              colorArg = "always";
              command = "delta --paging=never {{diffArgs}}";
            }
          ];
        };
        update.method = "never";
      };
    };
  };
}
