from __future__ import division

__author__ = 'mateusz'

import numpy
from sklearn import metrics
from matplotlib import pyplot
import gzip
import pickle
from pfile import pfile_read

def plot_confusion_matrix(cm, title='Confusion matrix', cmap=pyplot.cm.Blues):
    pyplot.imshow(cm, interpolation='nearest', cmap=cmap)
    pyplot.title(title)
    pyplot.colorbar()
    pyplot.tight_layout()
    pyplot.ylabel('True label')
    pyplot.xlabel('Predicted label')

nnet2file = 'nnet2/nnet2.classify.pickle.gz'
testpfile = 'workdir/test_FBANK.pfile'

utt_ids, frame_ids, features, labels = pfile_read(testpfile)

with gzip.open(nnet2file, 'rb') as f:
	nnet2 = pickle.load(f)

mpost = numpy.argmax(nnet2, axis=1)

labels = numpy.transpose(labels).flatten()

frame_err = numpy.count_nonzero(mpost - labels) / len(mpost)
print frame_err
# cm = metrics.confusion_matrix(labels, mpost)
# cm_normalized = cm.astype('float') / cm.sum(axis=1)[:, numpy.newaxis]

# pyplot.figure()
# plot_confusion_matrix(cm_normalized)
# pyplot.show()

# TODO: read this from workdir/states2id.lst
mapping = {
    0: 0, 1: 0, 2: 0,
	3: 1, 4: 1, 5: 1,
	6: 2, 7: 2, 8: 2,
	9: 3, 10: 3, 11: 3,
	12: 4, 13: 4, 14: 4,
	15: 5, 16: 5, 17: 5,
	18: 6, 19: 6, 20: 6,
	21: 7, 22: 7, 23: 7,
	24: 8, 25: 8, 26: 8,
	27: 9, 28: 9, 29: 9,
	30: 10, 31: 10, 32: 10,
	33: 11, 34: 11, 35: 11,
	36: 12, 37: 12, 38: 12,
	39: 13, 40: 13, 41: 13,
	42: 14, 43: 14, 44: 14,
	45: 15,
	46: 16, 47: 16, 48: 16,
	49: 17, 50: 17, 51: 17,
	52: 18, 53: 18, 54: 18,
	55: 19, 56: 19, 57: 19,
	58: 20, 59: 20, 60: 20,
	61: 21, 62: 21, 63: 21
}

phoneme_mpost = numpy.array([mapping[x] for x in mpost])
phoneme_labels = numpy.array([mapping[x] for x in labels])
phoneme_err = numpy.count_nonzero(phoneme_mpost - phoneme_labels) / len(phoneme_mpost)
print phoneme_err
phoneme_cm = metrics.confusion_matrix(phoneme_labels, phoneme_mpost)
phoneme_cm_normalized = phoneme_cm.astype('float') / phoneme_cm.sum(axis=1)[:, numpy.newaxis]

pyplot.figure()
plot_confusion_matrix(phoneme_cm_normalized)
pyplot.show()
