import numpy as np
from sklearn.tree import DecisionTreeRegressor
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
import cleandata


# Generate sample data
filename = './data_and_files/xy_csv/xy_stats172.csv'
data_raw = np.loadtxt(open(filename, "rb"),delimiter=",", skiprows=0)
y = data_raw[:, -10]
data, rows, cols = cleandata.cleandata(data_raw[:, :-11])
X = data
y = np.delete(y[:], rows, axis=0)

# To split the train set and the test set.
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)

trees = []
ys = []
for i in range(5):
    trees.append(DecisionTreeRegressor(max_depth=i*5+2))
    trees[i].fit(X_train, y_train)
    # The stage for prediction
    ys.append(trees[i].predict(X_test))

for i in range(5):
    plt.figure()
    # to get the sample axis
    T = np.array(range(X_test.shape[0]))
    plt.scatter(T, y_test, s=20, edgecolor="black", c="darkorange", label="data")
    plt.plot(T, ys[i], color="cornflowerblue", label="max_depth="+str(i*5+2), linewidth=2)
    plt.xlabel('data')
    plt.ylabel('target')
    plt.title("Decision Tree Regression")
    plt.legend()
    fig_filename = './DT/DT' + str(i) + '.png'
    plt.savefig(fig_filename)
    plt.show()
