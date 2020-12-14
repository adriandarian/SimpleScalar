###################
# Spec2000 Binary #
###################

inst=50000000 # MAX:INSTANCE
ff=20000000 # FAST:FORWARD
SSDIR=/root/build/simplesim-3.0 # Simple Sim 3.0 Directory
BENCHDIR=/root/benchmarks # Benchmarks Directory
SBDIR=/root/build/spec2000binaries # Spec 2000 Binaries Directory
SADIR=/root/build/spec2000args # Spec 2000 Arguments Directory
RSDIR=/root/build/runscripts # Run Scripts Directory

for path in /root/build/spec2000args/*; do
    [ -d "${path}" ] || continue # if not a directory, skip
    benchmark="$(basename "${path}")" # get benchmark as variable

    cp $RSDIR/RUN$benchmark $SADIR/$benchmark # copy benchmark over
    mkdir $SADIR/$benchmark/results # make the results output directory
    cd $SADIR/$benchmark # change directory to the benchmark 

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
done