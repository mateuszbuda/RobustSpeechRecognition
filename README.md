# RobustSpeechRecognition
[An Investigation Of Deep Neural Networks For Noise Robust Speech Recognition](http://research.microsoft.com/pubs/194344/0007398.pdf)

Recently, a new acoustic model based on deep neural networks (DNN) has been
introduced. While the DNN has generated significant improvements over GMM-based
systems on several tasks, there has been no evaluation of the robustness of such
systems to environmental distortion. In this paper, we investigate the noise
robustness of DNN-based acoustic models and find that they can match state-of-
the-art performance on the Aurora 4 task without any explicit noise
compensation. This performance can be further improved by incorporating
information about the environment into DNN training using a new method called
noise-aware training. When combined with the recently proposed dropout training
technique, a 7.5% relative improvement over the previously best published result
on this task is achieved using only a single decoding pass and no additional
decoding complexity compared to a standard DNN.

```
@INPROCEEDINGS{6639100, 
author={M. L. Seltzer and D. Yu and Y. Wang}, 
booktitle={2013 IEEE International Conference on Acoustics, Speech and Signal Processing}, 
title={An investigation of deep neural networks for noise robust speech recognition}, 
year={2013}, 
pages={7398-7402}, 
keywords={neural nets;speech recognition;Aurora 4 task;DNN-based acoustic models;GMM-based systems;decoding complexity;deep neural networks;environmental distortion;noise compensation;noise robust speech recognition;noise-aware training;single decoding pass;Hidden Markov models;Noise;Noise robustness;Speech;Speech recognition;Training;Aurora 4;adaptive training;deep neural network;noise robustness}, 
doi={10.1109/ICASSP.2013.6639100}, 
ISSN={1520-6149}, 
month={May},}
```


### Prerequisites ###

- Aurora dataset in the main directory.

- `workdirt/train.lst`

- `workdir{1-4}/test.lst`


### Dependencies ##

See `tools/modules_tegner`.


### Data ###

```
tools/prepare_data.sh
```

Should output:

- `workdirt/digitloop.grm`
- `workdirt/digitloop.lat`
- `workdirt/phones0.lst`
- `workdirt/phones1.lst`
- `workdirt/pron1.dic`
- `workdirt/recdict.dic`
- `workdirt/train_phone0.mlf`
- `workdirt/train_phone1.mlf`
- `workdirt/train_word.mlf`
- `workdirt/words.lst`
- `workdir{1-4}/phones0.lst`
- `workdir{1-4}/phones1.lst`
- `workdir{1-4}/pron1.dic`
- `workdir{1-4}/recdict.dic`
- `workdir{1-4}/test_word.mlf`

```
features=MFCC_0_D_A_Z
tools/train_g-hmm.sh $features
```

Should output:

- `models_MFCC_0_D_A_Z/proto`
- `models_MFCC_0_D_A_Z/hmm{1-7}/`


```
tools/train_gmm-hmm.sh $features
```

Should output:

- `models_MFCC_0_D_A_Z/hmm{8-19}/`

```
tools/forced_align_states.sh $features
```

Should output:

- `workdirt/train_tr_align.mlf`
- `workdirt/train_va_align.mlf`
- `workdir{1-4}/test_align.mlf`


### Feature Extraction ###

```
tools/phones2stateid.py workdirt/phones1.lst > workdirt/state2id.lst
```

```
python tools/htk2pfile.py workdirt/train_tr_align.mlf workdirt/state2id.lst FBANK_D_A workdirt/train_tr_FBANK_D_A.pfile
python tools/htk2pfile.py workdirt/train_va_align.mlf workdirt/state2id.lst FBANK_D_A workdirt/train_va_FBANK_D_A.pfile
python tools/htk2pfile.py workdir1/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir1/test_FBANK_D_A.pfile
python tools/htk2pfile.py workdir2/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir2/test_FBANK_D_A.pfile
python tools/htk2pfile.py workdir3/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir3/test_FBANK_D_A.pfile
python tools/htk2pfile.py workdir4/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir4/test_FBANK_D_A.pfile
```

```
./tools/normutts.sh workdirt/train_tr_FBANK_D_A.pfile workdirt/train_va_FBANK_D_A.pfile 
./tools/normutts.sh workdir1/test_FBANK_D_A.pfile workdir2/test_FBANK_D_A.pfile workdir3/test_FBANK_D_A.pfile workdir4/test_FBANK_D_A.pfile
```


### Tegner ###

Authentication with kerberos:

```
kinit -f -l 7d <username>@NADA.KTH.SE
```

Send `.pfile` files with training and test data together with other necessary files to tegner:

```
mkdir data
mv workdirt/*.pfile data/
mv workdir1/test_FBANK_D_A.pfile data/test1_FBANK_D_A.pfile
mv workdir2/test_FBANK_D_A.pfile data/test2_FBANK_D_A.pfile
mv workdir3/test_FBANK_D_A.pfile data/test3_FBANK_D_A.pfile
mv workdir4/test_FBANK_D_A.pfile data/test4_FBANK_D_A.pfile
```

```
ssh <username>@tegner.pdc.kth.se "mkdir /cfs/klemming/nobackup/<u>/<username>/data/"
scp data/train* <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/data/
scp data/test1_FBANK_D_A.pfile <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/data/
scp data/test2_FBANK_D_A.pfile <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/data/
scp data/test3_FBANK_D_A.pfile <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/data/
scp data/test4_FBANK_D_A.pfile <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/data/
scp tools/modules_tegner <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/
scp job_train.sh <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/
scp job_test.sh <username>@tegner.pdc.kth.se:/cfs/klemming/nobackup/<u>/<username>/
```

Notice: `data/test2_FBANK_D_A.pfile` and `data/test4_FBANK_D_A.pfile` are over 1GB and `scp` fails to copy them to tegner. You need to generate them there. Clone the repository and run feature extraction part for them and then copy to the `~/data/` folder.

Login to tegner:

```
ssh -Y <username>@tegner.pdc.kth.se
```

Setup Theano.
In your homedir create `.theanorc` file with the following content:

```
[global]
device = gpu0
floatX = float32
[nvcc]
fastmath = True
```


### Training DNNs ###

If you followed the steps above and have both `modules_tegner` and `job.sh` in your homedir, then just run:

```
mkdir nnet1 nnet2
sbatch job_train.sh
```

It trains two networks with 3 hidden layers with 2048 sigmoid units each.
The second network has additional dropout of 20% at each hidden layer.
It first runs 10 iterations of pre-training layer by layer in an unsupervised manner by treating each pair of layers as a RBM.
Then it runs 15 iterations with constant learning rate equal to 0.16.
Finally it finetunes both networks with 10 more iterations with a learning rate equal to 0.004.
For more details refer to `job_train.sh` script and [PDNN](https://www.cs.cmu.edu/~ymiao/pdnntk.html) documentation of [run_RBM](https://www.cs.cmu.edu/~ymiao/pdnntk/rbm.html) and [run_DNN](https://www.cs.cmu.edu/~ymiao/pdnntk/dnn.html).


### Testing ###

Assumes you have `test{1-4}_FBANK_D_A.pfile` test set files in `data/` folder. Then you just run

```
sbatch job_test.sh
```

For more details refer to `job_test.sh` script and [run_Extract_Feats](https://www.cs.cmu.edu/~ymiao/pdnntk/feat_ext.html) documentation.

