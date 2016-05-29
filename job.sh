#!/bin/bash

# The job name is used to determine the name of job output and error files
#SBATCH -J DT2118

# Set the time allocation to be charged
#SBATCH -A edu16.DT2118

# Request a mail when the job starts and ends
#SBATCH --mail-type=ALL

# Maximum job elapsed time should be indicated whenever possible
#SBATCH -t 04:00:00

# Number of nodes that will be reserved for a given job
#SBATCH --nodes=1


#SBATCH -e error.log
#SBATCH -o output.o

#SBATCH --gres=gpu:K80:2

# Run the executable file


source modules_tegner


# Train baseline DNN

(THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:64" \
--wdir ./nnet1 \
--activation sigmoid \
--lrate "C:0.1:15" \
--momentum 0.9 \
--batch-size 512 \
--param-output-file nnet1/nnet1.mdl \
--cfg-output-file nnet1/nnet1.cfg \
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:64" \
--ptr-file nnet1/nnet1.mdl \
--ptr-layer-number 3 \
--wdir ./nnet1/ \
--activation sigmoid \
--lrate "C:0.004:15" \
--momentum 0.9 \
--batch-size 512 \
--param-output-file nnet1/nnet1.mdl \
--cfg-output-file nnet1/nnet1.cfg \
|& tee -a nnet1/nnet1.log;

# Test baseline DNN

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test1_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "results/nnet1.test1.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test2_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "results/nnet1.test2.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test3_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "results/nnet1.test3.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test4_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet1/nnet1.mdl \
--nnet-cfg nnet1/nnet1.cfg \
--output-file "results/nnet1.test4.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet1/nnet1.log) &


# Train DNN with dropout

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:64" \
--wdir ./nnet2 \
--activation sigmoid \
--lrate "C:0.1:15" \
--momentum 0.9 \
--batch-size 512 \
--dropout-factor 0.2,0.2,0.2 \
--param-output-file nnet2/nnet2.mdl \
--cfg-output-file nnet2/nnet2.cfg \
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:64" \
--ptr-file nnet2/nnet2.mdl \
--ptr-layer-number 3 \
--wdir ./nnet2/ \
--activation sigmoid \
--lrate "C:0.004:15" \
--momentum 0.9 \
--batch-size 512 \
--dropout-factor 0.2,0.2,0.2 \
--param-output-file nnet2/nnet2.mdl \
--cfg-output-file nnet2/nnet2.cfg \
|& tee -a nnet2/nnet2.log;

# Test DNN with dropout

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test1_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "results/nnet2.test1.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test2_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "results/nnet2.test2.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test3_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "results/nnet2.test3.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_Extract_Feats.py \
--data "data/test4_FBANK_D_A.pfile,partition=600m,context=5,random=true" \
--nnet-param nnet2/nnet2.mdl \
--nnet-cfg nnet2/nnet2.cfg \
--output-file "results/nnet2.test4.classify.pickle.gz" \
--layer-index -1 \
--batch-size 512\
|& tee -a nnet2/nnet2.log

