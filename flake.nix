{
	description = "Home Manager configuration of arpit";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		base16.url = "github:SenchoPens/base16.nix";
	};

	outputs = { nixpkgs, home-manager, base16, ... }:
		let
			system = "x86_64-linux";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeConfigurations."arpit" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [
					./home.nix
					base16.homeManagerModule
				];
			};
		};
}
