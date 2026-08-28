# GNU Privacy Guard
{
  config,
  lib,
  pkgs,
  ...
}:
let
  gpgBackupScript = pkgs.writeShellApplication {
    name = "gpg-backup";
    runtimeInputs = [
      pkgs.bash
      pkgs.gnupg
      pkgs.gnutar
      pkgs.coreutils
      pkgs.findutils
    ];
    text = builtins.readFile ./gpg-backup.sh;
  };

  gpgBackupCompletion =
    pkgs.runCommand "gpg-backup-completion"
      {
        nativeBuildInputs = [ pkgs.installShellFiles ];
      }
      ''
        mkdir -p $out/share/zsh/site-functions
        installShellCompletion --zsh --name _gpg-backup ${pkgs.writeText "gpg-backup.zsh" (builtins.readFile ./gpg-backup.zsh)}
      '';

  gpgBackupScriptPkg = pkgs.symlinkJoin {
    name = "gpg-backup";
    paths = [
      gpgBackupScript
      gpgBackupCompletion
    ];
    meta = gpgBackupScript.meta or { };
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

    backup = {
      enable = lib.mkEnableOption "Enable the gpg-backup script";
      package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        default = gpgBackupScriptPkg;
        description = "The package for the gpg-backup script";
      };
    };
  };

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
    (lib.mkIf config.security.gpg.backup.enable {
      home.packages = [ config.security.gpg.backup.package ];
    })
  ];
}
