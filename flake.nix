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
    nixvim.url = "github:nix-community/nixvim";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      git-hooks,
      treefmt-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      updates = import ./updates {
        inherit pkgs;
        lib = pkgs.lib;
      };

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          stylua.enable = true;
          shfmt = {
            enable = true;
            indent_size = 2;
          };
        };
      };

      preCommitCheck = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          treefmt = {
            enable = true;
            package = treefmtEval.config.build.wrapper;
          };
          forbid-private = {
            enable = true;
            name = "Forbid committing private files";
            entry = "found private file in staging! Do not commit users/arpit/private.nix.";
            language = "system";
            files = "users/arpit/private\\.nix$";
            pass_filenames = false;
          };
        };
      };
    in
    {
      homeManagerModules = {
        default =
          {
            ...
          }:
          {
            imports = [
              nixvim.homeModules.nixvim
              ./modules
            ];
          };
      };
      apps.${system}.updates = {
        type = "app";
        program = "${updates}/bin/updates";
      };
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system} = {
        pre-commit-check = preCommitCheck;
        formatting = treefmtEval.config.build.check self;
      };
      devShells.${system}.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
        buildInputs = preCommitCheck.enabledPackages ++ [
          pkgs.lua-language-server
          pkgs.nixd
          pkgs.bash-language-server
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
