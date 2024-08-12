pkgs: let
  suites = import ./overlay.nix suites pkgs;
in
  suites
