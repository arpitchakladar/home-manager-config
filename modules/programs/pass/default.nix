# pass - Standard Unix password manager
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.programs.pass = {
    enable = lib.mkEnableOption "Enables pass.";

    package = lib.mkPackageOption pkgs "pass" { };

    storeDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.password-store";
      description = "Path to the pass password store.";
    };
  };

  config = lib.mkIf config.program.pass.enable {
    programs.password-store = {
      enable = true;
      package = config.program.pass.package;
      settings = {
        PASSWORD_STORE_DIR = config.program.pass.storeDir;
      };
    };

    home.file.".config/pass-git-helper/git-pass-mapping.ini".text = ''
      [github.com]
      target = github/token
      username = ${config.program.pass.github.username}
      username_extractor = static

      [github.com/*]
      target = github/token
      username = ${config.program.pass.github.username}
      username_extractor = static

      [*.github.com]
      target = github/token
      username = ${config.program.pass.github.username}
      username_extractor = static

      [*.github.com/*]
      target = github/token
      username = ${config.program.pass.github.username}
      username_extractor = static
    '';
  };
}
