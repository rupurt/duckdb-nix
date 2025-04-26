{
  description = "Nix flake for DuckDB";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    outputs = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlay
        ];
      };
    in {
      # packages exported by the flake
      packages = rec {
        main = pkgs.callPackage ./packages/main.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v1_2_2 = pkgs.callPackage ./packages/v1.2.2.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v1_2_1 = pkgs.callPackage ./packages/v1.2.1.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v1_2_0 = pkgs.callPackage ./packages/v1.2.0.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v1_1_3 = pkgs.callPackage ./packages/v1.1.3.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v0_10_2 = pkgs.callPackage ./packages/v0.10.2.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v0_10_1 = pkgs.callPackage ./packages/v0.10.1.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v0_10_0 = pkgs.callPackage ./packages/v0.10.0.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        v0_9_2 = pkgs.callPackage ./packages/v0.9.2.nix {
          stdenv = pkgs.libcxxStdenv;
        };
        default = v1_2_2;
      };

      # nix fmt
      formatter = pkgs.alejandra;
    });
  in
    outputs
    // {
      # Overlay that can be imported so you can access the packages
      # using duckdb-nix.overlay
      overlay = final: prev: {
        duckdb-pkgs = outputs.packages.${prev.system};
      };

      # nix flake init -t github:rupurt/duckdb-nix#multi
      templates = rec {
        multi = {
          description = "Multi version DuckDB template";
          path = ./templates/multi;
        };
        default = multi;
      };
    };
}
