# Author: Terence  翟瑞锟
# Date:   2018.5.19

'''
本程序可以进行SVM建模
parameters:	x   ndarray, each row indicates a sample, and each col indicates the related properties.
			y	ndarray 
'''
import numpy as np
from scipy import io as spio
from matplotlib import pyplot as plt
from sklearn import svm


def simplifylabel(labels):
	new_label = labels[:, 1]
	new_label = new_label > np.mean(new_label)
	new_label = new_label.astype(np.int64)

	return new_label


def svm(samples, labels)
	labels = simplifylabel(labels)
	model = svm.SVC(gamma=100).fit(samples, labels)
