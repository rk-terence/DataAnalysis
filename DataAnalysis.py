# -*- coding: utf-8 -*
import numpy as np
import pandas as pd


def zero_mean(data_mat):
    mean_val = np.mean(data_mat, axis = 0) # axis = 0 表示按列求均值
    new_data = data_mat - mean_val
    return new_data, mean_val

data_mat = pd.read_csv('data_and_files/xy_stats171_array.csv')
# variables = pd.read_csv('/data_and_files/variables171.csv')
meant_data, mean_val = zero_mean(data_mat)