# -*- coding: utf-8 -*-
# Author: Terence
# Date: 2018.5.13

import numpy as np
import cleandata as cd
# import pandas as pd


def pca(x):
    print('pca functioning...')
    height = x.shape[0]  # m是生产工单的个数

    x_norm, mu, sigma = normalize(x)  # 归一化

    covariance_matrix = np.dot(np.transpose(x_norm), x_norm) / height  # 求协方差矩阵

    u, s, v = np.linalg.svd(covariance_matrix)  # 特征值分解

    k = 50  # 降维到100维
    x_proj = projectdata(x_norm, u, k)
    print('投影之后Z向量的大小：%d %d' % x_proj.shape)

    # X_rec = recoverData(Z, U, K)  # 恢复数据

    print("Successfully implemented PCA!")
    return x_proj

'''本函数可以归一化对应的数据（使标准差为1，均值为0）'''


def normalize(data):
    # （每一个数据-当前列的均值）/当前列的标准差
    n = data.shape[1]
    mu = np.zeros((1, n))
    sigma = np.zeros((1, n))

    mu = np.mean(data, axis=0)  # axis=0表示列
    sigma = np.std(data, axis=0)
    for i in range(n):
        if sigma[i] == 0:
            data[:, i] = data[:, i] - mu[i]
        else:
            data[:, i] = (data[:, i] - mu[i]) / sigma[i]

    return data, mu, sigma


'''此函数可以映射数据到新的平面'''


def projectdata(x_norm, u, k):
    # z = np.zeros((x_norm.shape[0], k))
    u_reduced = u[:, 0:k]  # 取前K个特征值的向量作为新的坐标系。
    z = np.dot(x_norm, u_reduced)
    return z


if __name__ == "__main__":
    filename = './data_and_files/xy_csv/xy_stats172.csv'
    data_raw = np.loadtxt(open(filename, "rb"), delimiter=",", skiprows=0)
    x = data_raw[:, 1:-11]
    x_cleaned, cols = cd.cleandata(x)
    x_proj = pca(x_cleaned)


# a = np.where(x_cleaned != x_cleaned)
