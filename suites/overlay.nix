self: pkgs: let
  build-support = pkgs.callPackage ./build-support.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // self // build-support);
in {
  disk = callPackage ./disk {};
}
