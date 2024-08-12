{
  description = "A very basic flake";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nuenv = {
      # url = "github:DeterminateSystems/nuenv";
      url = "github:NotLebedev/nuenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    nuenv,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            nuenv.overlays.default
          ];
        };
        benches = import ./benches pkgs;
      in {
        packages.benches = benches;
        packages.suites = import ./suites (pkgs // {inherit benches;});

        devShells.default = pkgs.mkShell {
          buildInputs = [];
        };
      }
    );
}
