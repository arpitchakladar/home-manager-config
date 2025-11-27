{ config, pkgs, lib, ... }:

{
	options.tools.nnn = {
		enable = lib.mkEnableOption "Enables nnn.";
	};

	config = lib.mkIf config.tools.nnn.enable {
		home.sessionVariables = {
			# Start nnn in detail mode + show hidden items by default
			NNN_OPTS = "dH";
			NNN_FIFO = "/tmp/nnn.fifo";
		};

		programs.nnn = {
			enable = true;
			package = pkgs.nnn.override ({ withNerdIcons = true; });
			plugins = {
				src = "${config.programs.nnn.package}/share/plugins";
				mappings = {
					p = "preview-tui";
				};
			};
			extraPackages = with pkgs; [
				bat
				ffmpeg
				ffmpegthumbnailer
				ueberzugpp
			];
		};
	};
}
