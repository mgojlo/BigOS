{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Update when changing zig version
    zls.url = "github:zigtools/zls/0.14.0";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    zig-version = "0.14.0";
  in
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.zig-overlay.overlays.default
            (_: prev: {
              zls = inputs.zls.packages.${system}.zls;
            })
          ];
        };
        pkgsCross = import nixpkgs {
          inherit system;
          crossSystem = {config = "riscv64-none-elf";};
        };
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgsCross.buildPackages.binutils
            pkgs.zigpkgs.${zig-version}
            pkgs.zls
          ];
        };
      }
    );
}
