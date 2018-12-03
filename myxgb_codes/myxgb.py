'''
本module使用xgboost进行数据处理。仍待完善画图环节。
Time: June 15th, 2018
By RK Terence

待改进的地方：
1. 可以数据的loading环节放到一个函数里面，这样可以节省每个脚本的代码行数。
2. 画图，可视化建模结果
3. 调参
4. 将10种检测变量结合起来（需要自己想办法，XGBoost不支持多输出）


报告说明：

这个部分附加了一个图，和朱晨浩的部分是一个互补的关系。他分析的是对于提升XGBoost的Boosting次数对建模结果和预测结果带来的增益。因为他做的仅仅有[叶丝填充值]这一个测试结果，结果不够广度，所以我继续做了其他10个变量的较为简单的分析，放到了一个图里面，我做的部分是XGBoost建模对于10个变量的分析。具体：

研究XGBoost对10个输出变量进行独立建模得到的均方根误差，并根据均方根误差作图。图像里面，X轴是不同的输出，Y轴是均方根误差（RMSE）。从图像里面的值，结合下面的10个检测变量的粗略估计的平均值。
5 50 15 15 1.5 82 30 70 40 1.5
结合图片，可以看出，10个变量的均方误差也满足这样的比例关系。而对于单一的某个输出指标，RMSE和平均值的比值大概为：
0.125/5 = 0.025
粗略分析，这样大概满足误差的要求。
'''



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

    # specify parameters via map, definition are same as c++ version
    param = {'max_depth':3, 'eta':1, 'silent':1, 'objective':'reg:linear'}

    # specify validations set to watch performance
    watchlist = [(dtest, 'eval'), (dtrain, 'train')]
    num_round = 5
    mydict = {}
    # Training and prediction
    bst = xgb.train(param, dtrain, num_round, watchlist, evals_result=mydict)
    rmses.append(mydict['eval']['rmse'][4])
    # save the booster model
    bst.save_model('171_BoosterModel')

# to plot the result for each y
plt.figure()
plt.plot(T, rmses, linewidth=2)
plt.xlabel('yi')
plt.ylabel('target')
plt.title("XGBoost regression")
fig_filename = './figures/y_rmses.png'
plt.savefig(fig_filename)
plt.show()
