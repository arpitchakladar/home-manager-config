{ lib, config, ... }:

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
    programs.git = {
      settings = {
        user = {
          name = config.programs.git.username;
          email = config.programs.git.email;
        };
        credential.helper = "store --file ${config.xdg.cacheHome}/git/credential";
        core.askPass = "";
      };
    };

    # The base directory of the credential file must exist
    home.activation.createGitCacheDirectory = lib.hm.dag.entryAfter [
      "writeBoundary"
    ] "mkdir -p ${config.xdg.cacheHome}/git";
  };
}
