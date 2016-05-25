#!/bin/bash

# The job name is used to determine the name of job output and error files
#SBATCH -J test.DT2118

# Set the time allocation to be charged
#SBATCH -A edu16.DT2118

# Request a mail when the job starts and ends
#SBATCH --mail-type=ALL

# Maximum job elapsed time should be indicated whenever possible
#SBATCH -t 08:00:00

# Number of nodes that will be reserved for a given job
#SBATCH --nodes=1


#SBATCH -e error_test.log
#SBATCH -o output_test.o

#SBATCH --gres=gpu:K80:2

# Run the executable file

source modules_tegner

(THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test1_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "nnet1.test1.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test2_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "nnet1.test2.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test3_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "nnet1.test3.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test4_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "nnet1.test4.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log;) &


THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test1_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "nnet2.test1.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test2_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "nnet2.test2.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test3_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "nnet2.test3.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test4_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "nnet2.test4.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log;
