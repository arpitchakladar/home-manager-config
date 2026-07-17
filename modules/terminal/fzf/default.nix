# FZF - Fuzzy finder, CLI fuzzy search tool
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./assertions.nix ];

  options.terminal.fzf = {
    enable = lib.mkEnableOption "Enables fzf.";
    package = lib.mkPackageOption pkgs "fzf" { };
  };

  config =
    let
      shellIntegration = ''
        ${if config.terminal.zsh.enable then "eval \"$(fzf --zsh)\"" else "eval \"$(fzf --bash)\""}
      '';
    in
    lib.mkIf config.terminal.fzf.enable {
      programs.fzf = {
        enable = true;
        package = config.terminal.fzf.package;
        defaultOptions = [
          "--height 100%"
          "--layout=reverse"
          ''--pointer=\" \"''
          ''--header=\" \"''
          ''--prompt=\" \"''
          ''--marker=\"✓ \"''
          "--border=none"
          "--cycle"
          "--no-info"
          "--margin=\"1,2\""
        ];

        colors = with config.scheme.withHashtag; {
          fg = base05;
          bg = "-1";
          hl = base0D;

          "fg+" = base07;
          "bg+" = "-1";
          "hl+" = base0D;

          gutter = "-1";

          info = base0B;
          border = base03;
          prompt = base0A;
          pointer = base0F;
          marker = base0C;
          spinner = base0C;
        };
      };

      programs.zsh.initContent = lib.mkIf config.terminal.zsh.enable (lib.mkAfter shellIntegration);
      programs.bash.initExtra = lib.mkIf config.terminal.bash.enable (lib.mkAfter shellIntegration);
    };
}
