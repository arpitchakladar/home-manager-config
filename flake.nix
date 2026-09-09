# Home Manager configuration for Arpit's NixOS system.
# The module set is also exposed as `homeManagerModules.default` so other
# configurations can import this repo as a flake input.
{
  description = "Home Manager configuration of arpit, exposing a reusable homeManagerModules.default.";
  inputs = {
    # Use nixpkgs from the local registry to save disk space on duplicate derivations
    nixpkgs.url = "nixpkgs";
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
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
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
      updates = import ./updates {
        inherit pkgs;
        lib = pkgs.lib;
      };
      # The module set, bundled with the prerequisites it relies on: the
      # base16 module (provides `config.scheme`) and the nixvim module
      # (provides `programs.nixvim`). A default `scheme` is set so it works
      # out of the box; consumers can override it with their own path.
      homeManagerModule =
        {
          lib,
          ...
        }:
        {
          imports = [
            base16.homeManagerModule
            nixvim.homeModules.nixvim
            ./modules
          ];
          scheme = lib.mkDefault ./assets/onedark-dark.yml;
        };
    in
    {
      homeManagerModules = {
        default = homeManagerModule;
      };
      apps.${system}.updates = {
        type = "app";
        program = "${updates}/bin/updates";
      };
      formatter.${system} = pkgs.nixfmt-tree;
      devShells.${system}.default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          (
            { ... }:
            {
              git-hooks.hooks.nixfmt.enable = true;

              git-hooks.hooks.forbid-private = {
                enable = true;
                name = "Forbid committing private files";
                entry = "found private file in staging! Do not commit users/arpit/private.nix.";
                language = "fail";
                files = "users/arpit/private\\.nix$";
              };

              languages = {
                lua = {
                  enable = true;
                  lsp = {
                    enable = true;
                    package = pkgs.lua-language-server;
                  };
                };
                nix = {
                  enable = true;
                  lsp = {
                    enable = true;
                    package = pkgs.nixd;
                  };
                };
                shell = {
                  enable = true;
                  lsp = {
                    enable = true;
                    package = pkgs.bash-language-server;
                  };
                };
              };
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
              ./users/arpit
              self.homeManagerModules.default
            ];
          };
      };
    };
}
