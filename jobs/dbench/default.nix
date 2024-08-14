{
  mkBench,
  dbench,
  nprocs ? 12,
}:
mkBench {
  name = "dbench";
  version = "0.1.0";

  packages = [dbench];

  env = {
    inherit nprocs;
    tmp_dir = "tmp";
    timelimit = 10;
  };

  run = ''
    mkdir $env.tmp_dir
    enter $env.tmp_dir

    let result = dbench $env.nprocs -c ${dbench}/share/loadfiles/client.txt -t $env.timelimit | str join

    dexit
    rm -r $env.tmp_dir

    let index = $result | str index-of 'Throughput'
    let result = ($result
      | str substring $index..
      | parse "Throughput {throughput} MB/sec  ${toString nprocs} clients  ${toString nprocs} procs  max_latency={latency} ms\n"
      | get 0
      | to json)

    $result
  '';
}
