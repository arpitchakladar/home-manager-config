{
	description = "Home Manager configuration of arpit.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		base16.url = "github:SenchoPens/base16.nix";
		tt-schemes = {
			url = "github:tinted-theming/schemes";
			flake = false;
		};
	};

	outputs = { nixpkgs, home-manager, base16, ... }@inputs:
		let
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeConfigurations."arpit" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home.nix
					./modules
					base16.homeManagerModule
					{
						scheme = "${inputs.tt-schemes}/base16/onedark-dark.yaml";
					}
				];
			};
		};
}
