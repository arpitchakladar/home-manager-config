# Delta - A syntax-highlighting pager for git, diff, and grep output
{
  config,
  lib,
  ...
}:
{
  options.development.delta = {
    enable = lib.mkEnableOption "Enables delta.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.delta.finalPackage;
      description = "The delta package to use.";
    };
  };

  config = lib.mkIf config.development.delta.enable {
    programs.delta = {
      enable = true;
      options = {
        line-numbers = true;
        hunk-header-style = "omit";
        hunk-header-decoration-style = "omit";
        line-numbers-left-format = "{nm}│ ";
        line-numbers-right-format = "{np}│ ";
      };
    };

    programs.git.settings = lib.mkIf config.development.git.enable {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
    };

    programs.lazygit.settings = lib.mkIf config.development.lazygit.enable {
      git.pagers = [
        {
          colorArg = "always";
          pager = "delta --paging=never {{diffArgs}}";
        }
      ];
    };
  };
}
