from __future__ import division
# import time

import numpy as np

from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import train_test_split
import cleandata
from sklearn.decomposition import PCA
# from sklearn.model_selection import learning_curve
# import matplotlib.pyplot as plt


# #############################################################################
# Generate sample data
filename = './data_and_files/xy_csv/xy_stats172.csv'
# Delete the NaN value inside the data.
data_raw = np.loadtxt(open(filename, "rb"),delimiter=",", skiprows=0)
y = data_raw[:, -10]
data, rows, cols = cleandata.cleandata(data_raw[:, :-11])
X = data
y = np.delete(y[:], rows, axis=0)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)
pca = PCA(n_components=50).fit(X_train)
X_train_pca = pca.transform(X_train)
X_test_pca = pca.transform(X_test)

# #############################################################################
# Fit regression model
svr = GridSearchCV(SVR(kernel='rbf', gamma=0.1), cv=5,
                   param_grid={"C": [1e0, 1e1, 1e2, 1e3],
                               "gamma": np.logspace(-2, 2, 5)})
svr.fit(X_train, y_train)
y_pred = svr.predict(X_test)

