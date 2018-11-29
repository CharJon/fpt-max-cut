#!/bin/bash

if [ ! "$bootstrap_done" = true ] ; then
    source ./bootstrap.sh
fi

./$selected_build -action "kernelization" -iterations 10 -disk-suite realworld -live-maxcut-analysis -total-allowed-solver-time -1 \
                  -benchmark-output ../data/output/experiments/solvers/real-world/out > ../data/output/experiments/solvers/real-world/out-exe


#to test solvers: ./benchmark-debug -action "kernelization" -iterations 1 -sample-kagen 1 -benchmark-output ../data/output/experiments/solvers/real-world/out-test -total-allowed-solver-time 2