{ lib, config, ... }:

{
	imports = [
		./git-cola
	];

	options.tools.git = {
		enable = lib.mkEnableOption "Enables git.";
		username = lib.mkOption {
			type = lib.types.str;
			description = "Github username.";
		};
		email = lib.mkOption {
			type = lib.types.str;
			description = "Github email.";
		};
	};

	config = lib.mkIf config.tools.git.enable {
		programs.git.enable = true;
		programs.git.userName = config.tools.git.username;
		programs.git.userEmail = config.tools.git.email;
		programs.git.extraConfig = {
			credential.helper = "store --file ${config.xdg.cacheHome}/git/credential";
			core.askPass = "";
		};

		# The base directory of the credential file must exist
		home.activation.createGitCacheDirectory
			= lib.hm.dag.entryAfter
				[ "writeBoundary" ]
				"mkdir -p ${config.xdg.cacheHome}/git";
	};
}
