# Author: Terence  翟瑞锟
# Date:   2018.5.19

'''
本程序可以进行SVM建模
parameters:	x   ndarray, each row indicates a sample, and each col indicates the related properties.
            y   ndarray

存在的bug：
    1. 同cleandata，使用的label是清洗之后的label。更希望使用的label是原始的label。但是，目前来看并不严重。
'''


import numpy as np
from sklearn import svm
from sklearn.decomposition import PCA
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import classification_report
from sklearn.metrics import confusion_matrix
from matplotlib import pyplot as plt
# 自己的module
import cleandata
# import pca


def simplify_label(labels):
    new_label = labels[:, 1]
    new_label = new_label > np.mean(new_label)
    new_label = new_label.astype(np.int64)
    return new_label


def mysvm(samples, labels):
    model = svm.SVC(gamma=100).fit(samples, labels)
    return model


def plot_data(x,y):
    plt.figure(figsize=(10,8))
    pos = np.where(y==1)    # 找到y=1的位置
    neg = np.where(y==0)    # 找到y=0的位置
    p1, = plt.plot(np.ravel(x[pos,0]),np.ravel(x[pos,1]),'ro',markersize=8)
    p2, = plt.plot(np.ravel(x[neg,0]),np.ravel(x[neg,1]),'g^',markersize=8)
    plt.xlabel("variable1")
    plt.ylabel("variable2")
    plt.legend([p1,p2],["y==1","y==0"])
    plt.show()
    return plt


# 画出SVM处理结果
def plot_decisionboundary(x, y, model):
    plt = plot_data(x, y)

    x_1 = np.transpose(np.linspace(np.min(x[:,0]),np.max(x[:,0]),).reshape(1,-1))
    x_2 = np.transpose(np.linspace(np.min(x[:,1]),np.max(x[:,1]),100).reshape(1,-1))
    x1,x2 = np.meshgrid(x_1,x_2)
    vals = np.zeros(x1.shape)
    for i in range(x1.shape[1]):
        this_x = np.hstack((x1[:,i].reshape(-1,1),x2[:,i].reshape(-1,1)))
        vals[:,i] = model.predict(this_x)

    plt.contour(x1,x2,vals,[0,1],color='blue')
    plt.show()


if __name__ == '__main__':
    # Data training session
    filename = './data_and_files/xy_csv/xy_stats172.csv'
    data_raw = np.loadtxt(open(filename,"rb"),delimiter=",",skiprows=0)
    data, rows, cols = cleandata.cleandata(data_raw)
    samples = data[:, 1:-11]
    labels = data[:, -10:-1]
    labels = simplify_label(labels)  # 使用叶丝填充值简化label
    # Use PCA to reduce the dimension
    X_train, X_test, y_train, y_test = train_test_split(samples, labels, test_size=0.3)
    pca = PCA(n_components=50).fit(X_train)
    X_train_pca = pca.transform(X_train)
    X_test_pca = pca.transform(X_test)
    # 对数据进行svm处理，得到svm模型，同时画出边界图像
    param_grid = {'C': [1e3, 5e3, 1e4, 5e4, 1e5],
                  'gamma': [0.0001, 0.0005, 0.001, 0.005, 0.01, 0.1], }
    clf = GridSearchCV(svm.SVC(kernel='rbf', class_weight='balanced'), param_grid)
    svm_model = mysvm(X_train_pca, y_train)
    y_pred = svm_model.predict(X_test_pca)
    print(classification_report(y_test, y_pred))
    print(confusion_matrix(y_test, y_pred, labels=range(1)))

