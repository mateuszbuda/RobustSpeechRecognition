#!/bin/bash
# Forced Alignment on the training set of the Aurora database. Performs Viterbi
# decoding using the orthographic transcriptions and returns time-aligned phonetic
# transriptions. It uses the GMM-HMM models trained by train_mixup.sh
# Used for Project in the DT2118 Speech and Speaker Recognition course.
#
# Usage:
# ./forced_align.sh feature_code
# Example:
# ./forced_align.sh MFCC_0_D_A_Z
#
# Note: it takes about 15 minutes to run on a i5 processor at 2.5GHz
#
# (C) 2015 Giampiero Salvi <giampi@kth.se>
function recho {
    tput setaf 1;
    echo $1;
    tput sgr0;
}

# read arguments
features=$1

config0=config/input_format.cfg
config=config/features_$features.cfg

recho "Running forced alignment with features $features ..."
recho "...training data"
HVite -A -o SW -f -b 'SENT-START' -C $config0 -C $config -a -H models_$features/hmm19/hmmdefs.mmf -i workdirt/train_tr_align.mlf -m -t 250.0 -I workdirt/train_word.mlf -S workdirt/train_tr.lst workdirt/recdict.dic workdirt/phones1.lst
recho "...validation data"
HVite -A -o SW -f -b 'SENT-START' -C $config0 -C $config -a -H models_$features/hmm19/hmmdefs.mmf -i workdirt/train_va_align.mlf -m -t 250.0 -I workdirt/train_word.mlf -S workdirt/train_va.lst workdirt/recdict.dic workdirt/phones1.lst
recho "...test data"
HVite -A -o SW -f -b 'SENT-START' -C $config0 -C $config -a -H models_$features/hmm19/hmmdefs.mmf -i workdir1/test_align.mlf -m -t 250.0 -I workdir1/test_word.mlf -S workdir1/test.lst workdir1/recdict.dic workdir1/phones1.lst
HVite -A -o SW -f -b 'SENT-START' -C $config0 -C $config -a -H models_$features/hmm19/hmmdefs.mmf -i workdir2/test_align.mlf -m -t 250.0 -I workdir2/test_word.mlf -S workdir2/test.lst workdir2/recdict.dic workdir2/phones1.lst
HVite -A -o SW -f -b 'SENT-START' -C $config0 -C $config -a -H models_$features/hmm19/hmmdefs.mmf -i workdir3/test_align.mlf -m -t 250.0 -I workdir3/test_word.mlf -S workdir3/test.lst workdir3/recdict.dic workdir3/phones1.lst
HVite -A -o SW -f -b 'SENT-START' -C $config0 -C $config -a -H models_$features/hmm19/hmmdefs.mmf -i workdir4/test_align.mlf -m -t 250.0 -I workdir4/test_word.mlf -S workdir4/test.lst workdir4/recdict.dic workdir4/phones1.lst
recho "Finished, results stored in workdirt/train_tr_align.mlf, workdirt/train_va_align.mlf and workdir{1-4}/test_align.mlf"

