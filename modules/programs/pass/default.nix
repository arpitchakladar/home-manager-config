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
  };

  config = lib.mkIf config.programs.pass.enable {
    programs.password-store = {
      enable = true;
      package = config.programs.pass.package;
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/pass";
      };
    };
  };
}
