import numpy as np
import pandas as pd

loandata = pd.DataFrame(pd.read_excel('data_and_files/test.xlsx'))
a = loandata.dropna()
