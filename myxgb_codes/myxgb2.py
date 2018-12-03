import xgboost as xgb
from sklearn.model_selection import train_test_split
import numpy as np
import matplotlib.pyplot as plt
# My own modules
import cleandata
# Others' modules
import sys
sys.path.append('../')


# Generate sample data
# X_c and y_c contains all the outputs and all the input features(after preprocessing)
# 叶丝填充值，长丝率，中丝率，短丝率，碎丝率，整丝率。
# -10，       -9，   -8，    -7，   -6，    -5.
# filename = '../data_and_files/xy_csv/xy_stats172.csv'
filename = 'newdata_modified.csv'
data_raw = np.loadtxt(open(filename, "rb"),delimiter=",", skiprows=0)
y_c = data_raw[:, -10:]
data, rows, cols = cleandata.cleandata(data_raw[:, :-11])
X_c = data
y_c = np.delete(y_c[:], rows, axis=0)

# split the train data and the test data
for i in [-10, -9, -8, -7, -6, -5]:
    X_train, X_test, y_train, y_test = train_test_split(X_c, y_c[:,i], test_size=0.3)

    # load the dtrain and dtest data format for xgboost
    dtrain = xgb.DMatrix(X_train, label=y_train)
    dtest = xgb.DMatrix(X_test, label=y_test)

    # specify parameters via map, definition are same as c++ version
    param = {'max_depth': 3, 'eta': 1, 'silent': 1, 'objective': 'reg:linear'}

    # specify validations set to watch performance
    watchlist = [(dtest, 'eval'), (dtrain, 'train')]
    num_round = 5
    # Training and prediction
    bst = xgb.train(param, dtrain, num_round, watchlist)
    # save the booster model
    bst.save_model('171_BoosterModel')

    preds = bst.predict(dtest)
    # 取其中的20个数据点，便于观察。
    cols = range(20)
    preds = preds[cols]
    y_test = y_test[cols]
    # to plot the result for each y
    plt.figure()
    plt.plot(range(preds.shape[0]), preds, linewidth=2, c='r')
    plt.plot(range(y_test.shape[0]), y_test, linewidth=2, c='g')
    plt.xlabel('WorkOrder')
    plt.ylabel("Test Variable: "+str(i+11))
    plt.title("The Comparison of Original Label and Predicted Value Using XGBoost")
    fig_filename = './figures/新数据预测和原始结果对比图'+str(i+11)+'.png'
    plt.savefig(fig_filename)
    plt.show()
