### training set ###

Contains:

- clean1, clean2, clean3, clean4
- N1_SNR5, N1_SNR10, N1_SNR15
- N2_SNR5, N2_SNR10, N2_SNR15
- N3_SNR5, N3_SNR10, N3_SNR15
- N4_SNR5, N4_SNR10, N4_SNR15

Noise types included:

- subway
- babble
- car
- exhibition

### validation set ###

Makes up 11% of the original training set.

Extracted with:

```
$ awk '/\/FA/||/\/FB/||/\/MA/||/\/MB/' train.lst > train_va.lst
$ awk '!/\/FA/&&!/\/FB/&&!/\/MA/&&!/\/MB/' train.lst > train_tr.lst
```

```
$ wc -l train_va.lst 
     739 train_va.lst

$ wc -l train_tr.lst
    6013 train_tr.lst
````
