# GNU Privacy Guard
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../../lib/script.nix { inherit lib pkgs; })) mkScriptModule;
  gpgBackup = mkScriptModule {
    scope = [
      "security"
      "gpg"
    ];
    name = "gpg-backup";
    path = ./gpg-backup.sh;
    description = "Export/import all GPG keys as a single passphrase-protected file with maximum S2K iteration count\nUsage: gpg-backup export filename.gpg | gpg-backup import filename.gpg";
    deps = [
      pkgs.bash
      pkgs.gnupg
      pkgs.gnutar
      pkgs.coreutils
      pkgs.findutils
    ];
    completion.zsh = builtins.readFile ./gpg-backup.zsh;
    inherit config;
  };
in
{
  options.security.gpg = {
    enable = lib.mkEnableOption "Enables gpg.";

    package = lib.mkOption {
      type = lib.types.package;
      default = config.programs.gpg.package;
      readOnly = true;
      defaultText = lib.literalExpression "config.programs.gpg.package";
      description = "The gpg package to use.";
    };
  }
  // gpgBackup.options.security.gpg;

  config = lib.mkMerge [
    (lib.mkIf config.security.gpg.enable {
      programs.gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };

      home.sessionVariables = {
        GNUPGHOME = config.programs.gpg.homedir;
      };

      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        defaultCacheTtl = 3600;
        maxCacheTtl = 86400;
        enableSshSupport = config.security.ssh.enable;
        pinentry.package = pkgs.pinentry-rofi;
      };
    })
    gpgBackup.config
  ];
}
