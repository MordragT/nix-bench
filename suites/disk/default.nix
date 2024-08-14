{
  lib,
  nuenv,
  jobs,
}:
nuenv.writeScriptBin {
  name = "disk-suite";
  script = ''
    let sqlite = ${lib.getExe jobs.sqlite} | from json
    let rand-read = ${lib.getExe jobs.fio-randread} | from json
    let rand-write = ${lib.getExe jobs.fio-randwrite} | from json
    let read = ${lib.getExe jobs.fio-read} | from json
    let write = ${lib.getExe jobs.fio-write} | from json

    {
      sqlite: $sqlite,
      rand-read: $rand-read,
      rand-wrtie: $rand-write,
      read: $read,
      write: $write,
    }
  '';
}
