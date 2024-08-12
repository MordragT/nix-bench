{
  nuenv,
  benches,
}:
nuenv.writeScriptBin {
  name = "disk-suite";
  script = ''
    ${benches.sqlite}/bin/sqlite-bench
  '';
}
