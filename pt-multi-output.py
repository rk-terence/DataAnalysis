import numpy as np
from sklearn.tree import DecisionTreeRegressor
import matplotlib.pyplot as plt
import cleandata


# Generate sample data
filename = './data_and_files/xy_csv/xy_stats172.csv'
data_raw = np.loadtxt(open(filename, "rb"),delimiter=",", skiprows=0)
y = data_raw[:, -10:-8]
data, rows, cols = cleandata.cleandata(data_raw[:, :-11])
X = data
y = np.delete(y[:], rows, axis=0)

# To split the train set and the test set.
n_train_samples = int(X.shape[0] * 0.7)
X_train = X[:n_train_samples, :]
X_test = X[n_train_samples+1:-1, :]
y_train = y[:n_train_samples, :]
y_test = y[n_train_samples+1:-1, :]

# Fit regression model
tree_1 = DecisionTreeRegressor(max_depth=2)
tree_2 = DecisionTreeRegressor(max_depth=5)
tree_3 = DecisionTreeRegressor(max_depth=8)
tree_1.fit(X_train, y_train)
tree_2.fit(X_train, y_train)
tree_3.fit(X_train, y_train)

# Predict
y_1 = tree_1.predict(X_test)
y_2 = tree_2.predict(X_test)
y_3 = tree_3.predict(X_test)

# Plot the results
plt.figure()
s = 25
plt.scatter(y_test[:, 0], y_test[:, 1], c="navy", s=s,
            edgecolor="black", label="data")
plt.scatter(y_1[:, 0], y_1[:, 1], c="cornflowerblue", s=s,
            edgecolor="black", label="max_depth=2")
plt.scatter(y_2[:, 0], y_2[:, 1], c="red", s=s,
            edgecolor="black", label="max_depth=5")
plt.scatter(y_3[:, 0], y_3[:, 1], c="orange", s=s,
            edgecolor="black", label="max_depth=8")
plt.xlabel("target 1")
plt.ylabel("target 2")
plt.title("Multi-output Decision Tree Regression")
plt.legend(loc="best")
plt.show()