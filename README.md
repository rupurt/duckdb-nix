# duckdb-nix

Nix flake for development with multiple DuckDB versions

## Versions

- [main](https://github.com/duckdb/duckdb/commits/main)
- [v1.1.3](https://github.com/duckdb/duckdb/releases/tag/v1.1.3)
- [v0.10.2](https://github.com/duckdb/duckdb/releases/tag/v0.10.2)
- [v0.10.1](https://github.com/duckdb/duckdb/releases/tag/v0.10.1)
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
            pkgs.duckdb-pkgs.v1_1_3
            # pkgs.duckdb-pkgs.v0_10_2
            # pkgs.duckdb-pkgs.v0_10_1
            # pkgs.duckdb-pkgs.v0_10_0
            # pkgs.duckdb-pkgs.v0_9_2
            # pkgs.duckdb-pkgs.main
          ];
        };
      };
    );
}
```

## License

`duckdb-nix` is released under the [MIT license](./LICENSE)
