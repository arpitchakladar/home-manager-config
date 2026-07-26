# Neomutt - Email suite entry point (neomutt + mbsync + notmuch)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./account
    ./sync
    ./assertions.nix
    ./keybindings.nix
    ./macros.nix
    ./neomutt.nix
  ];

  options.communication.neomutt = {
    enable = lib.mkEnableOption "Email suite (neomutt + mbsync + notmuch)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.symlinkJoin {
        name = "neomutt-wrapped";
        paths = [ pkgs.neomutt ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/neomutt \
            --prefix PATH : ${lib.makeBinPath [ pkgs.urlscan ]}
        '';
        meta.mainProgram = "neomutt";
      };
      defaultText = lib.literalExpression ''
        pkgs.symlinkJoin {
          name = "neomutt-wrapped";
          paths = [ pkgs.neomutt ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = '''
            wrapProgram $out/bin/neomutt \
              --prefix PATH : ''${lib.makeBinPath [ pkgs.urlscan ]}
          ''';
          meta.mainProgram = "neomutt";
        }
      '';
      description = "The neomutt package to use, wrapped with urlscan in PATH.";
    };
  };

  config = lib.mkIf config.communication.neomutt.enable {
    accounts.email.maildirBasePath = "${config.home.homeDirectory}/.local/share/mail";
    home.sessionVariables.MAILDIR = config.accounts.email.maildirBasePath;
  };
}
