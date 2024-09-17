{
	description = "Home Manager configuration of arpit";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		stylix.url = "github:danth/stylix";
	};

	outputs = { nixpkgs, home-manager, stylix, ... }:
		let
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeConfigurations."arpit" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home.nix
					stylix.homeManagerModules.stylix
				];
			};
		};
}
