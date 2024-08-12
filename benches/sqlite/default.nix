{
  nuenv,
  sqlite,
}:
nuenv.writeScriptBin {
  name = "sqlite-bench";
  script = ''
    def cleanup [] {
      (0..3 | each {|n| rm $"bench-($n).db" })
    }

    def bench [n] {
      let db = $"bench-($n).db"
      ${sqlite}/bin/sqlite3 $db "CREATE TABLE pts1 ('I' SMALLINT NOT NULL, 'DT' TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 'F1' VARCHAR(4) NOT NULL, 'F2' VARCHAR(16) NOT NULL);"
      cat ${./sqlite-2500-insertions.txt} | ${sqlite}/bin/sqlite3 $db
      cat ${./sqlite-2500-insertions.txt} | ${sqlite}/bin/sqlite3 $db
      cat ${./sqlite-2500-insertions.txt} | ${sqlite}/bin/sqlite3 $db
    }

    let time = timeit (0..3 | par-each {|n| bench $n })
    cleanup
    $time
  '';
}
