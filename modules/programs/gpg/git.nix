{ config, lib, ... }:

{
  options.programs.git.signCommits = lib.mkEnableOption "GPG signing of git commits.";

  config = lib.mkIf config.programs.git.signCommits {
    assertions = [
      {
        assertion = config.programs.gpg.enable;
        message = "programs.git.signCommits requires programs.gpg.enable to be true.";
      }
    ];

    programs.git.settings = {
      commit.gpgSign = true;
    };
  };
}
