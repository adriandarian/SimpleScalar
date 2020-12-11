#!/bin/bash
# https://www.youtube.com/watch?v=zZA-NG5rQfg
source ~/.bashrc
# 1. Compile SimpleScalar
cd $SSDIR
make clean
make config-pisa
make
# 2. Compile a benchmark
cd $BENCHDIR/automotive/basicmath
make clean
make all
cd $BENCHDIR/network/dijkstra
make clean
make all
cd $BENCHDIR/office/stringsearch
make clean
make all
# 3. Run the following benchmarks
cd $BENCHDIR

# Predicator: Bimodial
# basicmath     jr_rate  = 0.9991  N=16, M=16,  W=4
# dijkstra      dir_rate = 0.9931  N=16, M=256, W=8
# stringsearch  jr_rate  = 0.9936  N=16, M=16,  W=4

# Benchmark: BASICMATH
# Predicator: BIMOD
# Meta Table Size: 512
# 2-Bit Counter Size: 512
A1=$BENCHDIR/automotive/basicmath
N=16  # BHT Size
M=16  # PHT Size
W=4   # BHT Width
$SSDIR/sim-bpred -bpred bimod -bpred:bimod 512 -bpred:2lev $N $M $W 0 $A1/basicmath_small |& egrep bpred_hier.bpred_jr_rate

# Benchmark: DIJKSTRA
# Predicator: BIMOD
# Meta Table Size: 512
# 2-Bit Counter Size: 512
N1=$BENCHDIR/network/dijkstra
N=16   # BHT Size
M=256  # PHT Size
W=4    # BHT Width
$SSDIR/sim-bpred -bpred bimod -bpred:bimod 512 -bpred:2lev $N $M $W 0 $N1/dijkstra_small $N1/input.dat |& egrep bpred_hier.bpred_dir_rate

# Benchmark: STRINGSEARCH
# Predicator: BIMOD
# Meta Table Size: 512
# 2-Bit Counter Size: 512
O1=$BENCHDIR/office/stringsearch
N=16  # BHT Size
M=16  # PHT Size
W=4   # BHT Width
$SSDIR/sim-bpred -bpred bimod -bpred:bimod 512 -bpred:2lev $N $M $W 0 $O1/search_small |& egrep bpred_hier.bpred_jr_rate