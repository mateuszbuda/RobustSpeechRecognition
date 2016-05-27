from __future__ import division

__author__ = 'mateusz'

import sys
from pfile import pfile_read, pfile_write
import numpy as np

filename = sys.argv[1]

utt_ids, frame_ids, features, frame_labels = pfile_read(filename)

sil1 = 42
sil2 = 43
sil3 = 44
sp = 45

indices = np.array([], dtype=int)
iSil1 = np.where(frame_labels == sil1)[0]
iSil2 = np.where(frame_labels == sil2)[0]
iSil3 = np.where(frame_labels == sil3)[0]
iSp = np.where(frame_labels == sp)[0]
indices = np.append(indices, iSil1)
indices = np.append(indices, iSil2)
indices = np.append(indices, iSil3)
indices = np.append(indices, iSp)

np.random.shuffle(indices)
fraction = 0.9
indices = indices[:fraction * len(indices)]

new_frame_labels = np.delete(frame_labels, indices, axis=0).astype(int)
new_features = np.delete(features, indices, axis=0)

new_utt_ids = np.delete(utt_ids, indices, axis=0).astype(int)
new_frame_ids = np.delete(frame_ids, indices, axis=0).astype(int)

new_frame_ids[0] = 0

for i in range(1, len(new_frame_ids)):
	if new_utt_ids[i - 1] != new_utt_ids[i]:
		new_frame_ids[i] = 0
	else:
		new_frame_ids[i] = new_frame_ids[i - 1] + 1

for i in range(0, 64):
	print(str(i) + ": " + str(np.count_nonzero(new_frame_labels == i) / len(new_frame_labels)))

pfile_write(filename, new_utt_ids, new_frame_ids, new_features, new_frame_labels)
