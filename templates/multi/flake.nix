{
  description = "Multi version DuckDB development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    duckdb-nix = {
      url = "github:rupurt/duckdb-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flake-utils,
    nixpkgs,
    duckdb-nix,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          duckdb-nix.overlay
        ];
      };
    in {
      # packages exported by the flake
      packages = {};

      # nix run
      apps = {};

      # nix fmt
      formatter = pkgs.alejandra;

      # nix develop -c $SHELL
      devShells = rec {
        # nix develop .#v0-10-0 -c $SHELL
        main = pkgs.mkShell.override {stdenv = pkgs.libcxxStdenv;} {
          name = "main dev shell";

          buildInputs = [];

          packages = [
            pkgs.duckdb-pkgs.main
          ];
        };

        # nix develop .#v0-10-0 -c $SHELL
        v0-10-0 = pkgs.mkShell.override {stdenv = pkgs.libcxxStdenv;} {
          name = "v0.10.0 dev shell";

          buildInputs = [];

          packages = [
            pkgs.duckdb-pkgs.duckdb-v0_10_0
          ];
        };

        # nix develop .#v0-9-2 -c $SHELL
        v0-9-2 = pkgs.mkShell.override {stdenv = pkgs.libcxxStdenv;} {
          name = "v0.9.2 dev shell";

          buildInputs = [];

          packages = [
            pkgs.duckdb-pkgs.duckdb-v0_9_2
          ];
        };

        # nix develop -c $SHELL
        default = v0-9-2;
      };
    });
  in
    outputs;
}
