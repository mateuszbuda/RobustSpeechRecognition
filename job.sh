#!/bin/bash

# The job name is used to determine the name of job output and error files
#SBATCH -J DT2118

# Set the time allocation to be charged
#SBATCH -A edu16.DT2118

# Request a mail when the job starts and ends
#SBATCH --mail-type=ALL

# Maximum job elapsed time should be indicated whenever possible
#SBATCH -t 05:00:00

# Number of nodes that will be reserved for a given job
#SBATCH --nodes=1


#SBATCH -e error.log
#SBATCH -o output.o

#SBATCH --gres=gpu:K80:2

# Run the executable file

source modules_tegner

(THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_RBM.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:2048:2048:64" \
--wdir ./nnet1 \
--param-output-file nnet1/nnet1.mdl \
--cfg-output-file nnet1/nnet1.cfg \
--epoch-number 10 \
--batch-size 512 \
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:2048:2048:64" \
--ptr-file nnet1/nnet1.mdl \
--ptr-layer-number 5 \
--wdir ./nnet1 \
--activation rectifier \
--lrate="C:0.16:15" \
--momentum 0.9 \
--batch-size 512 \
--param-output-file nnet1/nnet1.mdl \
--cfg-output-file nnet1/nnet1.cfg \
|& tee -a nnet1/nnet1.log;

THEANO_FLAGS='device=gpu0' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:2048:2048:64" \
--ptr-file nnet1/nnet1.mdl \
--ptr-layer-number 5 \
--wdir ./nnet1/ \
--activation rectifier \
--lrate="C:0.004:10" \
--momentum 0.9 \
--batch-size 512 \
--param-output-file nnet1/nnet1.mdl \
--cfg-output-file nnet1/nnet1.cfg \
|& tee -a nnet1/nnet1.log) &


THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_RBM.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:2048:2048:64" \
--wdir ./nnet2 \
--param-output-file nnet2/nnet2.mdl \
--cfg-output-file nnet2/nnet2.cfg \
--epoch-number 10 \
--batch-size 512 \
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:2048:2048:64" \
--ptr-file nnet2/nnet2.mdl \
--ptr-layer-number 5 \
--wdir ./nnet2 \
--activation rectifier \
--lrate="C:0.16:15" \
--momentum 0.9 \
--batch-size 512 \
--dropout-factor 0.2,0.2,0.2,0.2,0.2 \
--param-output-file nnet2/nnet2.mdl \
--cfg-output-file nnet2/nnet2.cfg \
|& tee -a nnet2/nnet2.log;

THEANO_FLAGS='device=gpu1' python $PDNNDIR/cmds/run_DNN.py \
--train-data "data/train_tr_FBANK_D_A.pfile,context=5,random=true" \
--valid-data "data/train_va_FBANK_D_A.pfile,context=5,random=true" \
--nnet-spec "792:2048:2048:2048:2048:2048:64" \
--ptr-file nnet2/nnet2.mdl \
--ptr-layer-number 5 \
--wdir ./nnet2/ \
--activation rectifier \
--lrate="C:0.004:10" \
--momentum 0.9 \
--batch-size 512 \
--dropout-factor 0.2,0.2,0.2,0.2,0.2 \
--param-output-file nnet2/nnet2.mdl \
--cfg-output-file nnet2/nnet2.cfg \
|& tee -a nnet2/nnet2.log
