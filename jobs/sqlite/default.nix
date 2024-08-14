{
  mkBench,
  sqlite,
}:
mkBench {
  name = "sqlite-bench";
  version = "0.1.0";

  packages = [sqlite];
  env = {
    tmp_dir = "tmp";
    rounds = 4;
  };

  run = ''
    use std bench
    use std log

    def run [] {
      let db = mktemp --suffix .db

      log info $"Created database at ($db)"

      sqlite3 $db "CREATE TABLE pts1 ('I' SMALLINT NOT NULL, 'DT' TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 'F1' VARCHAR(4) NOT NULL, 'F2' VARCHAR(16) NOT NULL);"
      cat ${./sqlite-2500-insertions.txt} | sqlite3 $db
      cat ${./sqlite-2500-insertions.txt} | sqlite3 $db
      cat ${./sqlite-2500-insertions.txt} | sqlite3 $db
    }

    log info "Starting SQLite benchmark"

    mkdir $env.tmp_dir
    enter $env.tmp_dir

    let result = bench -n $env.rounds --pretty { run } | to json

    dexit
    rm -r $env.tmp_dir

    $result
  '';
}
