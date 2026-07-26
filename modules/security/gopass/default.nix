# gopass - Standard Unix password manager (Go implementation)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.security.gopass = {
    enable = lib.mkEnableOption "Enables gopass.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.gopass.override { passAlias = true; };
      defaultText = lib.literalExpression "pkgs.gopass.override { passAlias = true; }";
      description = "The gopass package to use.";
    };
    ssh-agent = {
      enable = lib.mkEnableOption "gopass-backed SSH keys for git";
    };
  };
  config = lib.mkIf config.security.gopass.enable {
    programs.password-store = {
      enable = true;
      package = config.security.gopass.package;
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/pass";
      };
    };
    home.sessionVariables = {
      PASSWORD_STORE_DIR = config.programs.password-store.settings.PASSWORD_STORE_DIR;
    };
    systemd.user.services.gopass-ssh-load = lib.mkIf config.security.gopass.ssh-agent.enable {
      Unit = {
        Description = "Load SSH keys from gopass into SSH agent for git";
        After = [
          "gpg-agent.socket"
          "graphical-session.target"
        ];
        Requires = [
          "gpg-agent.socket"
        ];
        PartOf = [
          "graphical-session.target"
        ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "gopass-ssh-load" ''
          export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"

          if [ -z "$SSH_AUTH_SOCK" ] || [ ! -S "$SSH_AUTH_SOCK" ]; then
            exit 1
          fi

          for key in github gitlab bitbucket codeberg sourcehut; do
            if ${config.security.gopass.package}/bin/gopass cat "ssh/$key" > /dev/null 2>&1; then
              tmpdir=$(mktemp -d)
              keyfile="$tmpdir/key"
              ${config.security.gopass.package}/bin/gopass cat "ssh/$key" > "$keyfile" 2>/dev/null
              chmod 600 "$keyfile"
              if ! ${pkgs.openssh}/bin/ssh-add "$keyfile" 2>/dev/null; then
                passphrase=$(${config.security.gopass.package}/bin/gopass cat "ssh/$key/passphrase" 2>/dev/null)
                if [ -n "$passphrase" ]; then
                  tmpcopy=$(mktemp)
                  cp "$keyfile" "$tmpcopy"
                  chmod 600 "$tmpcopy"
                  if ${pkgs.openssh}/bin/ssh-keygen -p -P "$passphrase" -N "" -f "$tmpcopy" 2>/dev/null; then
                    ${pkgs.openssh}/bin/ssh-add "$tmpcopy" 2>/dev/null
                  fi
                  rm -f "$tmpcopy"
                fi
              fi
              rm -rf "$tmpdir"
            fi
          done
        ''}";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
