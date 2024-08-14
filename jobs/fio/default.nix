{
  mkBench,
  fio,
  rw,
  blocksize,
}:
mkBench {
  name = "fio-bench";
  version = "0.1.0";

  packages = [fio];
  env = {
    tmp_dir = "tmp";
    # global
    inherit rw blocksize;
    ioengine = "io_uring"; # libaio, io_uring
    iodepth = 64;
    size = "8m";
    direct = 0;
    startdelay = 20;
    force_async = 4;
    ramp_time = 5;
    runtime = 60;
    group_reporting = 1;
    numjobs = 32;
    time_based = true;
    clat_percentiles = 0;
    disable_lat = 1;
    disable_clat = 1;
    disable_slat = 1;
    filename = "tmp";
    # test
    name = "test";
    bs = 1;
    stonewall = true;
  };

  run = ''
    use std log

    log info "Starting Flexible IO benchmark"

    mkdir $env.tmp_dir
    enter $env.tmp_dir

    let force_async = if $env.ioengine == "io_uring" {
      $"force_async=($env.force_async)"
    } else {
      ""
    }

    let time_based = if $env.time_based {
      "time_based"
    } else {
      ""
    }

    let stonewall = if $env.stonewall {
      "stonewall"
    } else {
      ""
    }

    $"
    [global]
    rw=($env.rw)
    ioengine=($env.ioengine)
    iodepth=($env.iodepth)
    size=($env.size)
    blocksize=($env.blocksize)
    direct=($env.direct)
    startdelay=($env.startdelay)
    ($force_async)
    ramp_time=($env.ramp_time)
    runtime=($env.runtime)
    group_reporting=($env.group_reporting)
    numjobs=($env.numjobs)
    ($time_based)
    clat_percentiles=($env.clat_percentiles)
    disable_lat=($env.disable_lat)
    disable_clat=($env.disable_clat)
    disable_slat=($env.disable_slat)
    filename=($env.filename)
    [test]
    name=($env.name)
    bs=($env.bs)
    ($stonewall)
    " | save test.fio

    let result = fio --output-format=json test.fio

    dexit
    rm -r $env.tmp_dir

    if $env.rw == "read" || $env.rw == "randread" {
      $result.jobs.0.read
    } else {
      $result.jobs.0.write
    }
  '';
}
