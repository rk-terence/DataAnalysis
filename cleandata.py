# -*- coding: utf-8 -*-
# Author: Terence
# Date: 2018.5.13

'''
本程序可以将一个包含NaN值的ndarray类型数据进行数据清洗，处理掉其中的NaN值。具体的方法时删除数据条目（或属性，针对NaN较多的行或者列）、用平均值替代（针对NaN值较少的条目）。
Parameters:	ndarray
return:		ndarray
'''

import numpy as np


# 因为主要是Nan值，所以只需对NaN进行处理即可。
def cleandata(data):
    # 根据是否为NaN值，将array转化为逻辑array
    indices = data != data
    clean_data = np.copy(data)
    data[:, :] = 1
    data[indices] = 0

    # 删除大多数为nan的行
    i = 0
    rows = []  # rows储存需要删除的行。下面cols同理。
    length = clean_data.shape[1]
    while True:
        height = clean_data.shape[0]
        if i > height-1:
            break
        if np.sum(data[i, :]) < length*0.75:
            # clean_data = np.delete(clean_data, i, axis=0)  # 出现全nan行，删除数据。
            # data = np.delete(data, i, axis=0)
            rows.append(i)
            # continue  # continue的原因是删除了一行，i不变即下一行，下同
        i = i + 1
    clean_data = np.delete(clean_data, rows, axis=0)
    data = np.delete(data, rows, axis=0)

    # 删除大多数为nan的列
    i = 0
    cols = []
    height = clean_data.shape[0]
    while True:
        length = clean_data.shape[1]
        if i > length-1:
            break
        if np.sum(data[:, i]) < height*0.75:
            # clean_data = np.delete(clean_data, i, axis = 1)  # 删除 nan 列。
            # data = np.delete(data, i, axis = 1)
            cols.append(i)
        i = i + 1
    clean_data = np.delete(clean_data, cols, axis=1)
    data = np.delete(data, cols, axis=1)

    # 对于较少的为nan的行或者列，替换nan值（替换为其他的行的均值）
    height = clean_data.shape[0]
    indices = np.where(data == 0)

    for i in range(indices[0].size):
        clean_data[indices[0][i], indices[1][i]] = 0
    print("...")
    for i in range(indices[0].size):
        clean_data[indices[0][i], indices[1][i]] = np.sum(clean_data[:, indices[1][i]])/height

    print("Successfully implemented datacleaning!")
    return clean_data, cols


'''以下代码为测试函数的时候使用，直接运行此模块'''
if __name__ == "__main__":
    filename = './data_and_files/xy_csv/xy_stats172.csv'
    data_raw = np.loadtxt(open(filename,"rb"),delimiter=",",skiprows=0)

    x = data_raw[:,1:-11]
    x, cols = cleandata(x)
