# Secure shell client for encrypted remote connections
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.ssh;

  gpgSshKeyLoad = pkgs.writeShellApplication {
    name = "gpg-ssh-key-load";
    runtimeInputs = [
      config.terminal.bash.package
      config.security.gopass.package
      config.security.gpg.package
      cfg.package
      pkgs.coreutils
    ];
    text =
      builtins.replaceStrings
        [
          "@@GOPASS_SSH_KEY@@"
          "@@GNUPGHOME@@"
        ]
        [
          cfg.ssh-key-gopass-secret
          config.home.sessionVariables.GNUPGHOME
        ]
        (builtins.readFile ./gpg-ssh-key-load.sh);
  };
in
{
  options.security.ssh = {
    enable = lib.mkEnableOption "Enables ssh via the gpg-agent.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.openssh;
      description = "The ssh package to use.";
    };

    ssh-key-gopass-secret = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        gopass entry holding the private SSH key. The key is loaded into the
        gpg-agent during home-manager switch so ssh works without a ~/.ssh
        directory.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      assertions = [
        {
          assertion = config.security.gpg.enable;
          message = ''
            Enabling `security.ssh` requires `security.gpg` so that
            gpg-agent can be used as the ssh-agent.
          '';
        }
      ];
    })

    (lib.mkIf (cfg.enable && cfg.ssh-key-gopass-secret != null) {
      home.activation.gpgSshKeyLoad = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe gpgSshKeyLoad} || true
      '';
    })
  ];
}
