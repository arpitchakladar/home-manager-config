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
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      base16,
      nixvim,
      devenv,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system}.default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          (
            { ... }:
            {
              git-hooks.hooks.nixfmt.enable = true;
            }
          )
        ];
      };
      homeConfigurations = {
        arpit =
          let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
              inherit system;
            };
          in
          home-manager.lib.homeManagerConfiguration {
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
          };
      };
    };
}
