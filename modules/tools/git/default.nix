{ lib, config, ... }:

{
	options.tools.git = {
		enable = lib.mkEnableOption "Enables git.";
		username = lib.mkOption {
			type = lib.types.str;
			description = "Git username.";
		};
		email = lib.mkOption {
			type = lib.types.str;
			description = "Git email.";
		};
	};

	config = lib.mkIf config.tools.git.enable {
		programs.git = {
			enable = true;
			settings = {
				user.name = config.tools.git.username;
				user.email = config.tools.git.email;
				credential.helper = "store --file ${config.xdg.cacheHome}/git/credential";
				core.askPass = "";
			};
		};

		# The base directory of the credential file must exist
		home.activation.createGitCacheDirectory
			= lib.hm.dag.entryAfter
				[ "writeBoundary" ]
				"mkdir -p ${config.xdg.cacheHome}/git";
	};
}
