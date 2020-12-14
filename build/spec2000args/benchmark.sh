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
BRANCHPREDICTION="all" # Default branch prediction is to run all predictions
INSTANCE=50000000 # MAX:INSTANCE
FASTFORWARD=20000000 # FAST:FORWARD
NUMSETS=64 # BTB: Num Sets
ASSOCIATIVITY=2 # BTB: Associativity
RAS=8 # Return Address Stack
TABLESIZE=256 # BIMOD: Table Size
N=1 # 2Level: Branch History Table Size
M=256 # 2Level: Pattern History Table Size
W=4 # 2Level: Branch History Table Width
X=0 # 2Level: XoR
MTS=256 # COMB: Meta Table Size

while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--benchmark) BENCHMARK="$2"; shift ;;
        -p|--branch-prediction|--prediction) BRANCHPREDICTION="$2"; shift ;;
        -i|--instance) INSTANCE="$2"; shift ;;
        -f|--fast-forward) FASTFORWARD="$2"; shift ;;
        --btb) NUMSETS="$2"; ASSOCIATIVITY="$3"; shift ;;
        --ras) RAS="$2"; shift ;;
        --bimod) TABLESIZE="$2"; shift ;;
        --two-level) N="$2"; M="$3"; W="$4"; X="$5"; shift ;;
        -c|--comb) MTS="$2"; shift ;;
        *) echo "Unknown Option."; exit 2 ;;
    esac
    shift
done

runBranchPredictions () {
    benchmark=$1 # get benchmark as variable

    cp $RSDIR/RUN$benchmark $SADIR/$benchmark # copy benchmark over

    if [ ! -d "${path}" ]; then 
        mkdir $SADIR/$benchmark/results # make the results output directory
    fi
    cd $SADIR/$benchmark # change directory to the benchmark 

    case $BRANCHPREDICTION in
        "all")
            # Predicator: BIMOD
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/bimod.txt -bpred bimod -bpred:bimod $TABLESIZE -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
            # Predicator: 2LEVEL
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/2lev.txt -bpred 2lev -bpred:2lev $N $M $W $X -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
            # Predicator: COMB
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/comb.txt -bpred comb -bpred:comb $MTS -bpred:bimod $TABLESIZE -bpred:2lev $N $M $W $X -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
            # Predicator: TAKEN
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/taken.txt -bpred taken -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
            # Predicator: NOTTAKEN
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/nottaken.txt -bpred nottaken -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
        ;;
        "bimod")
            # Predicator: BIMOD
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/bimod.txt -bpred bimod -bpred:bimod $TABLESIZE -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
        ;;
        "2level"|"2lev")
            # Predicator: 2LEVEL
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/2lev.txt -bpred 2lev -bpred:2lev $N $M $W $X -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
        ;;
        "comb")
            # Predicator: COMB
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/comb.txt -bpred comb -bpred:comb $MTS -bpred:bimod $TABLESIZE -bpred:2lev $N $M $W $X -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
        ;;
        "taken")
            # Predicator: TAKEN
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/taken.txt -bpred taken -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
        ;;
        "nottaken"|"not-taken")
            # Predicator: NOTTAKEN
            $SADIR/$benchmark/RUN$benchmark $SSDIR/sim-outorder $SBDIR/"${benchmark}00.peak.ev6" -max:inst $INSTANCE -fastfwd $FASTFORWARD -redir:sim $SADIR/$benchmark/results/nottaken.txt -bpred nottaken -bpred:ras $RAS -bpred:btb $NUMSETS $ASSOCIATIVITY
        ;;
        *)
            echo "Branch Prediction method does not exist."
            exit 3
    esac
}

numBenchmarks=1 # Stored the number of benchmarks ran
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
        if [ "${1}" = "${benchmark}" ]; then
            return 0
        fi
    done

    return 1
}

start=`date +%s`
case $BENCHMARK in
    "all")
        runAllBranchPredictions
    ;;
    *)
        if verifyBenchmarkName $BENCHMARK
        then
            runBranchPredictions $BENCHMARK
        else
            echo "The Benchmark name specified is not from the list of benchmarks."
            exit 3
        fi
    ;;
esac
end=`date +%s`
runtime=$((end-start))

if [ $runtime -lt 10 ]
then
    echo "Please check the result files, it feels like an error occurred."
elif [ $numBenchmarks -ge 2 ]
then
    echo "Successfully completed all benchmarks in ${runtime} seconds."
else
    echo "Successfully completed ${BENCHMARK} benchmark in ${runtime} seconds."
fi