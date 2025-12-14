{
	description = "Home Manager configuration of arpit.";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		base16.url = "github:SenchoPens/base16.nix";
		nixvim.url = "github:nix-community/nixvim";
	};

	outputs = { nixpkgs, home-manager, base16, nixvim, ... }: {
		homeConfigurations = {
			arpit = let
				system = "x86_64-linux";
				pkgs = import nixpkgs { inherit system; };
			in home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./users/arpit.nix
					./modules
					base16.homeManagerModule
					{
						scheme = ./assets/onedark-dark.yml;
					}
					nixvim.homeModules.nixvim
				];
				minimal = true;
			};
		};
	};
}
