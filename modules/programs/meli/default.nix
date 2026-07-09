# meli - Terminal email client
{
  config,
  lib,
  pkgs,
  ...
}:

let
  mailDir = "${config.home.homeDirectory}/.local/mail";
in
{
  imports = [ ./assertions.nix ];

  config = lib.mkIf config.programs.meli.enable {
    home.packages = [ pkgs.meli ];

    xdg.configFile."meli/config.toml" = {
      text = ''
        [terminal]
        themes = "dark"

        [notifications]
        enable = false

        [pager]
        html_filter = "${pkgs.bat}/bin/bat --language=html"

        [composing]
        editor_command = "${pkgs.neovim}/bin/nvim"

        [pgp]
        auto_verify_signatures = true
        gpg_binary = "${pkgs.gnupg}/bin/gpg"

        [search]
        backend = "notmuch"
        database_path = "${mailDir}/.notmuch"
      '';
    };

    programs.zsh.initExtra = lib.mkAfter ''
      alias meli='meli-sync && meli'
    '';
  };
}
