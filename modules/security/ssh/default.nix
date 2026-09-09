# Secure shell client for encrypted remote connections
{
  config,
  lib,
  pkgs,
  ...
}:
let
  gpgSshKeyLoad = pkgs.writeShellApplication {
    name = "gpg-ssh-key-load";
    runtimeInputs = [
      config.terminal.bash.package
      config.security.gopass.package
      config.security.gpg.package
      config.security.ssh.package
      pkgs.coreutils
    ];
    text =
      builtins.replaceStrings
        [
          "@@GOPASS_SSH_KEY@@"
          "@@GNUPGHOME@@"
        ]
        [
          config.security.ssh.sshKeyGopassPath
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

    sshKeyGopassPath = lib.mkOption {
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
    (lib.mkIf config.security.ssh.enable {
      home.packages = [ config.security.ssh.package ];

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

    (lib.mkIf (config.security.ssh.enable && config.security.ssh.sshKeyGopassPath != null) {
      home.activation.gpgSshKeyLoad = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe gpgSshKeyLoad} || true
      '';
    })
  ];
}
