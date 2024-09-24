{ lib, config, ... }:

{
	options = {
		git.enable = lib.mkEnableOption "Enables git.";
	};

	config = lib.mkIf config.git.enable {
		programs.git.enable = true;
		programs.git.userEmail = "54011232+arpitchakladar@users.noreply.github.com";
		programs.git.userName = "Arpit Chakladar";
		programs.git.extraConfig = {
			credential.helper = "store --file ${config.xdg.cacheHome}/git/credential";
			core.askPass = "";
		};

		# The base directory of the credential file must exist
		home.activation.createGitCacheDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] "mkdir -p ${config.xdg.cacheHome}/git";
	};
}
