self: pkgs: let
  build-support = pkgs.callPackage ./build-support.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // build-support);
in {
  sqlite = callPackage ./sqlite {};
}
