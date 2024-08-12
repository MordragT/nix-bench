pkgs: let
  benches = import ./overlay.nix benches pkgs;
in
  benches
