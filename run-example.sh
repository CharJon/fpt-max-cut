#/bin/bash

func_localize() {
    local cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

    mkdir $cwd/build
    cd $cwd/build
    cmake ../
    make benchmark

    experiment_outdir=$cwd/output/experiments/kernelization/n1024
    mkdir -p $experiment_outdir/kernelization/n1024
    $cwd/build/./benchmark -action "kernelization" -iterations 1 -sample-kagen 16 -num-nodes 64 -num-edges-lo 0 -num-edges-hi $((64*4)) -total-allowed-solver-time 1 \
                -number-of-threads 4  -benchmark-output $experiment_outdir/out > $experiment_outdir/out-exe

    cd $cwd
}

func_localize