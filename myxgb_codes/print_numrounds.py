#Others' modules
import sys
sys.path.append('../')

import xgboost as xgb
from sklearn.model_selection import train_test_split
import numpy as np
import matplotlib.pyplot as plt

# My own modules
import cleandata

# Generate sample data
# X_c and y_c contains all the outputs and all the input features(after preprocessing)
filename = '../data_and_files/xy_csv/xy_stats172.csv'
data_raw = np.loadtxt(open(filename, "rb"),delimiter=",", skiprows=0)
y_c = data_raw[:, -10:]
data, rows, cols = cleandata.cleandata(data_raw[:, :-11])
X_c = data
y_c = np.delete(y_c[:], rows, axis=0)

# assert X_c.shape[0]==y_c.shape[0]
# print(X_c.shape[0])
rmses = []
T = range(10)
for i in range(10):
# specify the column of label:
    label_col = -10+i
# split the train data and the test data
    X_train, X_test, y_train, y_test = train_test_split(X_c, y_c[:,label_col], test_size=0.3)

# load the dtrain and dtest data format for xgboost
    dtrain = xgb.DMatrix(X_train, label=y_train)
    dtest = xgb.DMatrix(X_test, label=y_test)


for i in range(50):
    # specify parameters via map, definition are same as c++ version
    param = {'max_depth':4, 'eta':1, 'silent':1, 'objective':'reg:linear'}

    # specify validations set to watch performance
    watchlist = [(dtest, 'eval'), (dtrain, 'train')]
    num_round = i
    result_ = {}

    # Training and prediction
    bst = xgb.train(param, dtrain, num_round, watchlist, evals_result = result_)
    preds = bst.predict(dtest)
    labels = dtest.get_label()
    if 'eval' in result_:
        print(result_['eval']['rmse'])
        x_[i] = i
#       y_[i] = result_['eval']['rmse'][1]
    else:
        print('python is sb!')

    # save the booster model
plt.plot(x_, y_)
bst.save_model('171_BoosterModel')
