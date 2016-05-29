source tools/modules_tegner;

python tools/htk2pfile.py workdirt/train_tr_align.mlf workdirt/state2id.lst FBANK_D_A workdirt/train_tr_FBANK_D_A.pfile;
python tools/htk2pfile.py workdirt/train_va_align.mlf workdirt/state2id.lst FBANK_D_A workdirt/train_va_FBANK_D_A.pfile;
python tools/htk2pfile.py workdir1/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir1/test_FBANK_D_A.pfile;
python tools/htk2pfile.py workdir2/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir2/test_FBANK_D_A.pfile;
python tools/htk2pfile.py workdir3/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir3/test_FBANK_D_A.pfile;
python tools/htk2pfile.py workdir4/test_align.mlf workdirt/state2id.lst FBANK_D_A workdir4/test_FBANK_D_A.pfile;

./tools/normutts.sh workdirt/train_tr_FBANK_D_A.pfile workdirt/train_va_FBANK_D_A.pfile;
./tools/normutts.sh workdir1/test_FBANK_D_A.pfile workdir2/test_FBANK_D_A.pfile workdir3/test_FBANK_D_A.pfile workdir4/test_FBANK_D_A.pfile;

python tools/discountSilence.py workdirt/train_tr_FBANK_D_A.pfile;
python tools/discountSilence.py workdirt/train_va_FBANK_D_A.pfile;

mkdir data;
mv workdirt/*.pfile data/;
mv workdir1/test_FBANK_D_A.pfile data/test1_FBANK_D_A.pfile;
mv workdir2/test_FBANK_D_A.pfile data/test2_FBANK_D_A.pfile;
mv workdir3/test_FBANK_D_A.pfile data/test3_FBANK_D_A.pfile;
mv workdir4/test_FBANK_D_A.pfile data/test4_FBANK_D_A.pfile;

mkdir nnet1 nnet2 results;
sbatch job.sh;
