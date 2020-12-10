# https://www.youtube.com/watch?v=zZA-NG5rQfg
# 1. Compile SimpleScalar
# 2. Compile a benchmark
# 3. Run the following benchmarks

# Predicator: Hierarchical
# basicmath     jr_rate  = 0.9991  N=16, M=16,  W=4
# dijkstra      dir_rate = 0.9931  N=16, M=256, W=8
# stringsearch  jr_rate  = 0.9936  N=16, M=16,  W=4

# Benchmark: BASICMATH
# Predicator: HIER
# Meta Table Size: 512
# 2-Bit Counter Size: 512
A1=./automotive/basicmath
N=16  # BHT Size
M=16  # PHT SIze
W=4   # BHT Width
$SSDIR/sim-bpred -bpred hier -bpred:hier 512 -bpred:bimod 512 -bpred:2lev $N basicmath_small |& egrep bpred_hier.bpred_jr_rate

# Benchmark: DIJKSTRA
# Predicator: HIER
# Meta Table Size: 512
# 2-Bit Counter Size: 512
N1=./network/dijkstra
N=16   # BHT Size
M=256  # PHT SIze
W=4    # BHT Width
$SSDIR/sim-bpred -bpred hier -bpred:hier 512 -bpred:bimod 512 -bpred:2lev $N dijkstra_small $N1/input.dat |& egrep bpred_hier.bpred_dir_rate

# Benchmark: STRINGSEARCH
# Predicator: HIER
# Meta Table Size: 512
# 2-Bit Counter Size: 512
O1=./office/stringsearch
N=16  # BHT Size
M=16  # PHT SIze
W=4   # BHT Width
$SSDIR/sim-bpred -bpred hier -bpred:hier 512 -bpred:bimod 512 -bpred:2lev $N  $M $W 8 $o1/ basicmath_small |& egrep bpred_hier.bpred_jr_rate