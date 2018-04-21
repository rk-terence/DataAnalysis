import numpy as np
import pandas as pd
loandata = pd.DataFrame(pd.read_excel('../Data/1 生产过程统计数据.xlsx'))
# loandata.duplicated()
loandata.isnull()