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
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      base16,
      nixvim,
      pre-commit-hooks,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      checks.${system}.pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixfmt.enable = true;
        };
      };
      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system}.default = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
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
            extraSpecialArgs = {
              utils = import ./utils;
            };
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
