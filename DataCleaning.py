import numpy as np
import pandas as pd
# from scipy.interpolate import lagrange

loandata = pd.DataFrame(pd.read_excel('data_and_files/1 生产过程统计数据.xlsx'))
loandata.duplicated()
loandata.isnull()

processed_data = loandata.drop_duplicates()
processed_data = loandata.dropna()
