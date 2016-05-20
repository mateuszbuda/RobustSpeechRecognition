#!/bin/bash
# Data preparation for training and testing on the TIDIGIT database. Creates:
# - lists of relevant files,
# - orthographic labels based on the TIDIGIT filenames,
# - phonetic labels based on a dictionary
# - a loop-of-digit grammar
# Used for Lab 3 in the DT2118 Speech and Speaker Recognition course.
#
# Usage:
# ./prepare_data.sh
#
# (C) 2015 Giampiero Salvi <giampi@kth.se>
function recho {
    tput setaf 1;
    echo $1;
    tput sgr0;
}

recho "Preparing data for recognition experiment..."

#recho "...creating working directory if not existent"
#mkdir -p workdir

#recho "...create list of training files"
#find tidigits/disc_4.1.1/tidigits/train/ -name "*.wav" > workdir/train.lst
#recho "...create list of test files"
#find tidigits/disc_4.2.1/tidigits/test/ -name "*.wav" > workdir/test.lst

recho "...create Master Label File (word level, training data)"
tools/list2mlf.py workdirt/train.lst > workdirt/train_word.mlf
recho "...create Master Label File (word level, test data)"
tools/list2mlf.py workdir1/test.lst > workdir1/test_word.mlf
tools/list2mlf.py workdir2/test.lst > workdir2/test_word.mlf
tools/list2mlf.py workdir3/test.lst > workdir3/test_word.mlf
tools/list2mlf.py workdir4/test.lst > workdir4/test_word.mlf

recho "...create dictionary with shory pauses"
cat config/pron0.dic | awk '{printf("%s sp\n", $0)}' > workdirt/pron1.dic
cat config/pron0.dic | awk '{printf("%s sp\n", $0)}' > workdir1/pron1.dic
cat config/pron0.dic | awk '{printf("%s sp\n", $0)}' > workdir2/pron1.dic
cat config/pron0.dic | awk '{printf("%s sp\n", $0)}' > workdir3/pron1.dic
cat config/pron0.dic | awk '{printf("%s sp\n", $0)}' > workdir4/pron1.dic

recho "...expand pronunciations in labels into phonemes WITHOUT short pauses"
HLEd -d config/pron0.dic -i workdirt/train_phone0.mlf config/mkphones0.led workdirt/train_word.mlf
recho "...expand pronunciations in labels into phonemes WITH short pauses"
HLEd -d workdirt/pron1.dic -i workdirt/train_phone1.mlf config/mkphones1.led workdirt/train_word.mlf

recho "...create list of monophones WITHOUT short pauses"
tools/dict2phones.py config/pron0.dic > workdirt/phones0.lst
cp workdirt/phones0.lst workdir1/phones0.lst
cp workdirt/phones0.lst workdir2/phones0.lst
cp workdirt/phones0.lst workdir3/phones0.lst
cp workdirt/phones0.lst workdir4/phones0.lst
recho "...create list of monophones WITH short pauses"
tools/dict2phones.py workdirt/pron1.dic > workdirt/phones1.lst
cp workdirt/phones1.lst workdir1/phones1.lst
cp workdirt/phones1.lst workdir2/phones1.lst
cp workdirt/phones1.lst workdir3/phones1.lst
cp workdirt/phones1.lst workdir4/phones1.lst

recho "...generate list of words"
cat config/pron0.dic | awk '{print $1}' > workdirt/words.lst

recho "...create recognition grammar (loop of digits)"
tools/words2grammar.py workdirt/words.lst > workdirt/digitloop.grm
recho "...compile recognition grammar"
HParse workdirt/digitloop.grm workdirt/digitloop.lat

recho "...add start and end symbols to recognition dictionary"
echo "SENT-START [] sil" > workdirt/recdict.dic
echo "SENT-END [] sil" >> workdirt/recdict.dic
cat workdirt/pron1.dic >> workdirt/recdict.dic

cat workdirt/pron1.dic >> workdir1/recdict.dic
cat workdirt/pron1.dic >> workdir2/recdict.dic
cat workdirt/pron1.dic >> workdir3/recdict.dic
cat workdirt/pron1.dic >> workdir4/recdict.dic
recho "Finished."
