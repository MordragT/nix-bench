self: pkgs: let
  build-support = pkgs.callPackage ./build-support.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // build-support);
in {
  test = callPackage ./test {};

  dbench = callPackage ./dbench {};

  fio-randread = callPackage ./fio {
    rw = "randread";
    blocksize = 4 * 1024;
  };
  fio-randwrite = callPackage ./fio {
    rw = "randwrite";
    blocksize = 4 * 1024;
  };
  fio-seqread = callPackage ./fio {
    rw = "read";
    blocksize = 2 * 1024 * 1024;
  };
  fio-seqwrite = callPackage ./fio {
    rw = "write";
    blocksize = 2 * 1024 * 1024;
  };

  sqlite = callPackage ./sqlite {};
}
