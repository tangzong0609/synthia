{
  description = "Synthetic data generation subnet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=23.11";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };
        p2n = poetry2nix.lib.mkPoetry2Nix {
          inherit pkgs;
        };
        p2n-overrides = import ./nix/poetry2nix-overrides.nix {
          inherit pkgs p2n;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.python310
            pkgs.poetry
            pkgs.ruff
          ];
        };
        packages = rec {
          synthia = p2n.mkPoetryApplication {
            projectDir = ./.;
            python = pkgs.python311;
            overrides = p2n-overrides;
          };
          default = synthia;
        };
      });
}
