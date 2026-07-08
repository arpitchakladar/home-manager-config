{
  config,
  lib,
  pkgs,
  ...
}:

# Git - Distributed version control system
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
    home.packages = lib.mkIfconfig config.programs.pass.enable [ pkgs.pass-git-helper ];

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
            lib.optionalAttrs config.programs.pass.enable {
              credential."https://github.com" = {
                username = config.programs.pass.github.username;
                helper = lib.getExe pkgs.pass-git-helper;
              };
            }
          );
    };
  };
}
