{
  lib,
  nuenv,
}: {
  mkBench = {
    name,
    version,
    run,
    packages ? [],
    env ? {},
  }: let
    path = lib.concatMapStringsSep " " (p: "${p}/bin") packages;
    load-path = lib.optionalString ((lib.length packages) > 0) "std path add ${path}";
    load-env = "'${lib.strings.toJSON env}' | from json | load-env";
  in
    nuenv.writeScriptBin {
      name = "${name}-${version}";
      script = ''
        use std

        export def main [] {
          ${load-path}
          ${load-env}
          ${run}
        }
      '';
    };
}
