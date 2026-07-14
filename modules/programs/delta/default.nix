{
  config,
  lib,
  ...
}:
# Delta - A syntax-highlighting pager for git, diff, and grep output
{
  config = lib.mkIf config.programs.delta.enable {
    programs.git.settings = lib.mkIf config.programs.git.enable {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
    };

    programs.lazygit.settings = lib.mkIf config.programs.lazygit.enable {
      git.pagers = [
        {
          colorArg = "always";
          pager = "delta --paging=never {{diffArgs}}";
        }
      ];
    };
  };
}
