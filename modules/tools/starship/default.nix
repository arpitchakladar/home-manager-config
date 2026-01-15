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
				add_newline = true;

				format = ''
[╭─\[](red)$hostname[@](red)$username[\]](red)$directory$git_branch$git_status$nix_shell
[╰─](red)$status$character 
'';

				character.format = "[](red)";

				username = {
					style_user = "blue";
					style_root = "red bold";
					format = "[$user]($style)";
					show_always = true;
				};

				hostname = {
					ssh_only = false;
					style = "green";
					format = "[$hostname]($style)";
				};

				directory = {
					style = "purple";
					truncate_to_repo = false;
					format = mkSegment "$path";
				};

				git_branch = {
					style = "bold yellow";
					format = ''[┄\[](red)[$symbol$branch(:$remote_branch)]($style)'';
				};

				git_status = {
					style = "cyan";
					format = ''( [$all_status$ahead_behind]($style))[\]](red)'';
				};

				nix_shell = {
					format = mkSegment "$symbol $state( \($name\))";
					symbol = "󱄅";
					impure_msg = "󰻌";
					pure_msg = "󰕥";
				};

				status = {
					disabled = false;
					format = ''${mkSegment "$symbol $status"}[┄─](red)'';
					style = "white";
				};
			};
		};
	};
}
