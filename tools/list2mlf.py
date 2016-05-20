#!/usr/bin/python
# Convert filenames in the TIDIGIT database into labels in HTK MLF format
# Lab 3 in DT2118 Speech and Speaker Recognition
#
# Usage:
# ./list2mlf.py filelist.txt > labels.mlf
#
# (C) 2015 Giampiero Salvi <giampi@kth.se>
import sys
import re

num2text = {
    'O': 'oh',
    'Z': 'zero',
    '1': 'one',
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven',
    '8': 'eight',
    '9': 'nine',
}

filename = sys.argv[1]
f = open(filename)

# print header
print('#!MLF!#')

# for each filename create transcription
for line in f:
    labname = re.sub('.08$', '.lab', line.rstrip())
    filename = re.sub('.*\/', '', labname)
    digits = list(re.sub('[AB]\.lab', '', filename))
    digits = digits[4:]
    words = [num2text[d] for d in digits]
    print('\"'+labname+'\"')
    for w in words:
        print(w)
    print('.')
