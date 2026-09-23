# Fuzzy finder, CLI fuzzy search tool
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terminal.fzf;
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };

  shellIntegration = ''
    ${if config.terminal.zsh.enable then "eval \"$(fzf --zsh)\"" else "eval \"$(fzf --bash)\""}
  '';
in
{
  imports = [ ./assertions.nix ];

  options.terminal.fzf = {
    enable = lib.mkEnableOption "Enables fzf.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.fzf.package;
      description = "The fzf package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      defaultOptions = [
        "--height 100%"
        "--layout=reverse"
        "--pointer='󰠁 '"
        "--header=' '"
        "--prompt='󰎕 '"
        "--marker='✓ '"
        "--border=none"
        "--cycle"
        "--no-info"
        "--margin='1,2'"
      ];

      colors = with base16Colors.colorsWithHashPrefix; {
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
  };
}
