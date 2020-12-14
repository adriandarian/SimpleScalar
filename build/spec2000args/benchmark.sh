#!/bin/sh

###################
# Spec2000 Binary #
###################

if [ $# -eq 0 ]; then
    TEXT="Please:\n- Provide a benchmark to run.\n- So that I may generate some branch predictions.\n- Then launch this script again with an argument at hand."
    echo -e $TEXT
    exit 1
fi

# Declare Initial variables
SSDIR=/root/build/simplesim-3.0 # Simple Sim 3.0 Directory
BENCHDIR=/root/benchmarks # Benchmarks Directory
SBDIR=/root/build/spec2000binaries # Spec 2000 Binaries Directory
SADIR=/root/build/spec2000args # Spec 2000 Arguments Directory
RSDIR=/root/build/runscripts # Run Scripts Directory
instance=50000000 # MAX:INSTANCE
fastForward=20000000 # FAST:FORWARD
numSets=64 # BTB: Num Sets
associativity=2 # BTB: Associativity
RAS=8 # Return Address Stack
tableSize=256 # BIMOD: Table Size
N=1 # 2Level: Branch History Table Size
M=256 # 2Level: Pattern History Table Size
W=4 # 2Level: Branch History Table Width
X=0 # 2Level: XoR
MTS=256 # COMB: Meta Table Size
numBenchmarks=1 # Stored the number of benchmarks ran

runBranchPredictions () {
    benchmark=$1 # get benchmark as variable

    cp $RSDIR/RUN$benchmark $SADIR/$benchmark # copy benchmark over
    mkdir $SADIR/$benchmark/results # make the results output directory
    cd $SADIR/$benchmark # change directory to the benchmark 

    # Predicator: BIMOD
    $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $instance -fastfwd $fastForward -redir:sim $SADIR/$benchmark/results/bimod.txt -bpred bimod -bpred:bimod $tableSize -bpred:ras $RAS -bpred:btb $numSets $associativity

    # Predicator: 2LEVEL
    $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $instance -fastfwd $fastForward -redir:sim $SADIR/$benchmark/results/2lev.txt -bpred 2lev -bpred:2lev $N $M $W $X -bpred:ras $RAS -bpred:btb $numSets $associativity

    # Predicator: COMB
    $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $instance -fastfwd $fastForward -redir:sim $SADIR/$benchmark/results/comb.txt -bpred comb -bpred:comb $MTS -bpred:bimod $tableSize -bpred:2lev $N $M $W $X -bpred:ras $RAS -bpred:btb $numSets $associativity

    # Predicator: TAKEN
    $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $instance -fastfwd $fastForward -redir:sim $SADIR/$benchmark/results/taken.txt -bpred taken -bpred:ras $RAS -bpred:btb $numSets $associativity

    # Predicator: NOTTAKEN
    $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $instance -fastfwd $fastForward -redir:sim $SADIR/$benchmark/results/nottaken.txt -bpred nottaken -bpred:ras $RAS -bpred:btb $numSets $associativity
}

runAllBranchPredictions () {
    for path in /root/build/spec2000args/*; do
        [ -d "${path}" ] || continue # if not a directory, skip
        benchmark="$(basename "${path}")" # get benchmark as variable
        runBranchPredictions $basename
        numBenchmarks=$((numBenchmarks+1))
    done
}

verifyBenchmarkName () {
    for path in /root/build/spec2000args/*; do
        [ -d "${path}" ] || continue # if not a directory, skip
        benchmark="$(basename "${path}")" # get benchmark as variable
        if [ $1 -eq $benchmark ]; then
            return true
        fi
    done

    return false
}

start=`date +%s`
case $1 in
    "all")
        runAllBranchPredictions
    ;;
    *)
        if verifyBenchmarkName $1
        then
            runBranchPredictions $1
        else
            echo "The Benchmark name specified is not from the list of benchmarks."
            exit 2
        fi
    ;;
esac
end=`date +%s`
runtime=$((end-start))

echo "Successfully completed ${numBenchmarks} Benchmarks in ${runtime} seconds."