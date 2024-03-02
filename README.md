# duckdb-nix

Nix flake for development with multiple DuckDB versions

## Versions

- [main](https://github.com/duckdb/duckdb/commits/main)
- [v0.10.0](https://github.com/duckdb/duckdb/releases/tag/v0.10.0)
- [v0.9.2](https://github.com/duckdb/duckdb/releases/tag/v0.9.2)

## Usage

This `duckdb-nix` flake assumes you have already [installed nix](https://determinate.systems/posts/determinate-nix-installer)

### Flake Template

```shell
> nix flake init -t github:rupurt/duckdb-nix#multi
```

### Custom Flake with Overlay

```nix
# flake.nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.duckdb-nix.url = "github:rupurt/duckdb-nix";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
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
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            # pkgs.duckdb-pkgs.main             # main
            # pkgs.duckdb-pkgs.duckdb-v0_10_0   # v0.10.0
            pkgs.duckdb-pkgs.duckdb-v0_9_2      # v0.9.2
          ];
        };
      };
    );
}
```

## License

`duckdb-nix` is released under the MIT license
