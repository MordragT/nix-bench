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
        jobs = import ./jobs pkgs;
        suites = import ./suites (pkgs // {inherit jobs;});
      in {
        packages = {
          inherit jobs suites;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [];
        };
      }
    );
}
