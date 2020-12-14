##########################
# Spec2000 Binary Equake #
##########################

# MAX:INSTANCE 50000000
inst=50000000
# FAST:FORWARD 20000000
ff=20000000

benchmark='equake'
cp $RSDIR/RUN$benchmark $SADIR/$benchmark
mkdir $SADIR/$benchmark/results
cd $SADIR/$benchmark

# Predicator: BIMOD
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $inst -fastfwd $ff -redir:sim $SADIR/$benchmark/results/bimod.txt -bpred bimod -bpred:bimod 256 -bpred:ras 8 -bpred:btb 64 2

# Predicator: 2LEVEL
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst 50000000 -fastfwd $ff -redir:sim $SADIR/$benchmark/results/2lev.txt -bpred 2lev -bpred:2lev 1 256 4 0 -bpred:ras 8 -bpred:btb 64 2

# Predicator: COMB
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst 50000000 -fastfwd $ff -redir:sim $SADIR/$benchmark/results/comb.txt -bpred comb -bpred:comb 256 -bpred:bimod 256 -bpred:2lev 1 256 4 0 -bpred:ras 8 -bpred:btb 64 2

# Predicator: TAKEN
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst 50000000 -fastfwd $ff -redir:sim $SADIR/$benchmark/results/taken.txt -bpred taken -bpred:ras 8 -bpred:btb 64 2

# Predicator: NOTTAKEN
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst 50000000 -fastfwd $ff -redir:sim $SADIR/$benchmark/results/nottaken.txt -bpred nottaken -bpred:ras 8 -bpred:btb 64 2

##########################
# Spec2000 Binary Swim #
##########################

# MAX:INSTANCE 50000000
inst=50000000
# FAST:FORWARD 20000000
ff=20000000

benchmark='swim'
cp $RSDIR/RUN$benchmark $SADIR/$benchmark
mkdir $SADIR/$benchmark/results
cd $SADIR/$benchmark

# Predicator: BIMOD
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $inst -fastfwd $ff -redir:sim $SADIR/$benchmark/results/bimod.txt -bpred bimod -bpred:bimod 256 -bpred:ras 8 -bpred:btb 64 2

# Predicator: 2LEVEL
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $inst -fastfwd $ff -redir:sim $SADIR/$benchmark/results/2lev.txt -bpred 2lev -bpred:2lev 1 256 4 0 -bpred:ras 8 -bpred:btb 64 2

# Predicator: COMB
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $inst -fastfwd $ff -redir:sim $SADIR/$benchmark/results/comb.txt -bpred comb -bpred:comb 256 -bpred:bimod 256 -bpred:2lev 1 256 4 0 -bpred:ras 8 -bpred:btb 64 2

# Predicator: TAKEN
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $inst -fastfwd $ff -redir:sim $SADIR/$benchmark/results/taken.txt -bpred taken -bpred:ras 8 -bpred:btb 64 2

# Predicator: NOTTAKEN
$SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $inst -fastfwd $ff -redir:sim $SADIR/$benchmark/results/nottaken.txt -bpred nottaken -bpred:ras 8 -bpred:btb 64 2