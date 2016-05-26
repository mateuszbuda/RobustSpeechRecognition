from __future__ import division

__author__ = 'mateusz'

import argparse
import numpy
from sklearn import metrics
from matplotlib import pyplot, interactive
import gzip
import pickle
from pfile import pfile_read


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


def main(nnetfile, testpfile, info):
	with gzip.open(nnetfile, 'rb') as f:
		nnet = pickle.load(f)

	utt_ids, frame_ids, features, frame_labels = pfile_read(testpfile)

	# frame level evaluation

	frame_mpost = numpy.argmax(nnet, axis=1)
	frame_labels = numpy.transpose(frame_labels).flatten()

	frame_err = numpy.count_nonzero(frame_mpost - frame_labels) / len(frame_mpost)
	print(frame_err)

	frame_cm = metrics.confusion_matrix(frame_labels, frame_mpost)
	frame_cm_normalized = frame_cm.astype('float') / frame_cm.sum(axis=1)[:, numpy.newaxis]

	pyplot.figure()
	plot_confusion_matrix(frame_cm_normalized, title="Frame level confusion matrix for " + info)
	pyplot.show()

	# phoneme level evaluation

	phoneme_mpost = numpy.array([mapping[x] for x in frame_mpost])
	phoneme_labels = numpy.array([mapping[x] for x in frame_labels])

	phoneme_err = numpy.count_nonzero(phoneme_mpost - phoneme_labels) / len(phoneme_mpost)
	print(phoneme_err)

	phoneme_cm = metrics.confusion_matrix(phoneme_labels, phoneme_mpost)
	phoneme_cm_normalized = phoneme_cm.astype('float') / phoneme_cm.sum(axis=1)[:, numpy.newaxis]

	pyplot.figure()
	plot_confusion_matrix(phoneme_cm_normalized, title="Phoneme level confusion matrix for " + info)
	pyplot.show()


def plot_confusion_matrix(cm, title='Confusion matrix', cmap=pyplot.cm.Blues):
	pyplot.imshow(cm, interpolation='nearest', cmap=cmap)
	pyplot.title(title)
	pyplot.colorbar()
	pyplot.tight_layout()
	pyplot.ylabel('True label')
	pyplot.xlabel('Predicted label')


if __name__ == "__main__":

	parser = argparse.ArgumentParser()

	parser.add_argument('-r', '--result', type=str,
						help='Path to run_Extract_Feats output')
	parser.add_argument('-f', '--features', type=str,
						help='Path to labeled features file that was input to run_Extract_Feats')
	parser.add_argument('-i', '--info', type=str, default="",
						help='Info added to plots title')

	args = parser.parse_args()
	params = vars(args)

	interactive(True)

	main(params['result'], params['features'], params['info'])

	raw_input('')
