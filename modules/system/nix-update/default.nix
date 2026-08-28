# Update NixOS and/or Home Manager flake configuration
{
  config,
  lib,
  pkgs,
  ...
}:
let
  nixUpdateScript = pkgs.writeShellApplication {
    name = "nix-update";
    runtimeInputs = [
      pkgs.git
      pkgs.nix
      config.programs.home-manager.package
      pkgs.bash
    ];
    text = builtins.readFile ./nix-update.sh;
  };

  nixUpdateCompletion =
    pkgs.runCommand "nix-update-completion"
      {
        nativeBuildInputs = [ pkgs.installShellFiles ];
      }
      ''
        mkdir -p $out/share/zsh/site-functions
        installShellCompletion --zsh --name _nix-update ${pkgs.writeText "nix-update.zsh" (builtins.readFile ./nix-update.zsh)}
      '';

  nixUpdateScriptPkg = pkgs.symlinkJoin {
    name = "nix-update";
    paths = [
      nixUpdateScript
      nixUpdateCompletion
    ];
    meta = nixUpdateScript.meta or { };
  };
in
{
  options.system.nix-update = {
    enable = lib.mkEnableOption "Update NixOS and/or Home Manager flake configuration";

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = nixUpdateScriptPkg;
      description = "The nix-update script package.";
    };
  };

  config = lib.mkIf config.system.nix-update.enable {
    home.packages = [ config.system.nix-update.package ];
  };
}
