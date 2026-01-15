{ config, lib, ... }:

{
	options.tools.starship = {
		enable = lib.mkEnableOption "Enables starship.";
	};

	config = lib.mkIf config.tools.starship.enable {
		programs.starship = {
			enable = true;
			enableZshIntegration = config.tools.zsh.enable;
			settings =
			let
				mkSegment = content: ''[┄\[](red)[${content}]($style)[\]](red)'';
			in {
				add_newline = true;# Single line layout

				format = ''
[╭─\[](red)[$username](bold green)[@](red)[$hostname](bold blue)[\]](red)$directory$git_branch$git_status
[╰─](red)$status$character 
'';

				character.format = "[>](bold red)";

				username = {
					style_user = "green";
					style_root = "red bold";
					format = "[$user]($style)";
					show_always = true;
				};

				hostname = {
					ssh_only = false;
					style = "blue";
					format = "[$hostname]($style)";
				};

				directory = {
					style = "purple";
					truncate_to_repo = false;
					format = mkSegment "$path";
				};

				git_branch = {
					style = "bold yellow";
					format = mkSegment "$symbol$branch(:$remote_branch)";
				};

				git_status = {
					format = mkSegment "$all_status$ahead_behind";
					style = "cyan";
				};

				status = {
					disabled = false;
					format = ''${mkSegment "$symbol $status"}[┄─](red)'';
					style = "cyan";
				};
			};
		};
	};
}
