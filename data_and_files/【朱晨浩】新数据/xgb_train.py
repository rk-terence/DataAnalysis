import pandas as pd
import xgboost as xgb
import math
import matplotlib.pyplot as plt

def loadDataset(filePath):
    df = pd.read_csv(filepath_or_buffer=filePath)
    return df

def featureSet(data):
    data_num = len(data)
    XList = []
    for row in range(0, data_num):
        tmp_list = []
        for col in range(1, 67):
            tmp_list.append(data.iloc[row]['x' + str(col)])
        XList.append(tmp_list)
    yList = data.y.values
    return XList, yList

def loadTestData(filePath):
    data = pd.read_csv(filepath_or_buffer=filePath)
    data_num = len(data)
    XList = []
    for row in range(0, data_num):
        tmp_list = []
        for col in range(1, 67):
            tmp_list.append(data.iloc[row]['x' + str(col)])
        XList.append(tmp_list)
    yList = data.y.values
    return XList, yList


def trainandTest(X_train, y_train, X_test, y_test, para):
    model = xgb.XGBRegressor(max_depth=5, learning_rate=0.1, n_estimators=160,
                             silent=True, objective='reg:gamma')
    model.fit(X_train, y_train)

    ans = model.predict(X_test)
    error = 0
    for i in range(len(ans)):
        error += (ans[i] - y_test[i]) * (ans[i] - y_test[i])
    error /= len(ans)
    error = math.sqrt(error)
    print('error of value ' + str(para + 1) + ' is ' + str(error))

    #xgb.plot_importance(model)
    xgb.plot_tree(model, num_trees=100)
    plt.show()

if __name__ == '__main__':
    #para = 1
    for para in range(1) :

        trainFilePath = 'train' + str(para + 1) + '.csv'
        testFilePath = 'test' + str(para + 1) + '.csv'
        data = loadDataset(trainFilePath)
        X_train, y_train = featureSet(data)
        X_test, y_test = loadTestData(testFilePath)
        trainandTest(X_train, y_train, X_test, y_test, para)
