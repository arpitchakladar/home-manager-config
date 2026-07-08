{
  config,
  lib,
  pkgs,
  ...
}:

# Git - Distributed version control system
let
  passCfg = config.programs.pass;
  passGitHelper = lib.getExe pkgs.pass-git-helper;
in
{
  options.programs.git = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Git username.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "Git email.";
    };
  };

  config = lib.mkIf config.programs.git.enable {
    programs.git = {
      settings =
        lib.recursiveUpdate
          {
            user = {
              name = config.programs.git.username;
              email = config.programs.git.email;
            };
            core.askPass = "";
          }
          (
            lib.optionalAttrs passCfg.enable {
              credential."https://github.com" = {
                username = passCfg.github.username;
                helper = passGitHelper;
              };
            }
          );
    };
  };
}
