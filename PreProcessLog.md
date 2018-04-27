# 2018.4.24 数据提取环节

今天进行数据的预处理。

预定使用的软件为Matlab R2017b。准备先把各个sheet导入到Matlab的变量里面，然后再对这些变量写特定的程序脚本来处理。

## 1. excel中数据的提取

数据的提取分为两个部分，一个是生产过程中的数据，一个是过程检验数据。为了制成excel表格，我们需要对数据进行提取。

### 1.1. 生产过程数据的提取

使用如下的代码把`1 生产过程统计数据.xlsx` 中的内容提取到matlab的工作变量中：

`ExtractInfo.m` 

```matlab
%此程序可以对过程生产数据进行数据的提取，提取到matlab中。

filename = "StatisticsInProduction.xlsx";

for i = 1:24
	%获得参数
    sheetname = GenSheetname(i);
    xls = xlsread(filename,sheetname);
    endrow = length(xls);
    
    %对varname进行处理
    if i <= 6
        varname = "15" + string(i + 6);            
    else
        if i <= 18
            varname = "16" + string(i - 6);
        else
            varname = "17" + string(i - 18);
        end
    end
    
    %使用eval函数生成变量名、提取数据
    eval('raw_' + varname + ' = ' + 'importfilefromexcel(filename, sheetname, 2, endrow);');
end
```

代码中，`function GenSheetname`是一个自定义的函数，它可以根据月份序号得到excel表中对应的sheet名。`eval`函数可以方便我们对变量名进行命名，这也是解释型语言的一个优势。核心函数是`importfilefromexcel(filename, sheetname, startrow, endrow)` ，它的定义如下（由MATLAB的GUI程序辅助生成）。

`importfilefromexcel.m` 

```matlab
function tableout = importfilefromexcel(workbookFile,sheetName,startRow,endRow)
%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 45603;
end

%% Import the data, extracting spreadsheet dates in Excel serial date format
[~, ~, raw, dates] = xlsread(workbookFile, sheetName, sprintf('A%d:L%d',startRow(1),endRow(1)),'' , @convertSpreadsheetExcelDates);
for block=2:length(startRow)
    [~, ~, tmpRawBlock,tmpDateNumBlock] = xlsread(workbookFile, sheetName, sprintf('A%d:L%d',startRow(block),endRow(block)),'' , @convertSpreadsheetExcelDates);
    raw = [raw;tmpRawBlock]; %#ok<AGROW>
    dates = [dates;tmpDateNumBlock]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
stringVectors = string(raw(:,[2,10,11,12]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[1,4,5,6,7,8,9]);
dates = dates(:,3);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),dates); % Find non-numeric cells
dates(R) = {NaN}; % Replace non-numeric Excel dates with NaN

%% Create output variable
I = cellfun(@(x) ischar(x), raw);
raw(I) = {NaN};
data = reshape([raw{:}],size(raw));

%% Create table
tableout = table;

%% Allocate imported array to column variable names
tableout.VarName1 = data(:,1);
tableout.VarName2 = categorical(stringVectors(:,1));
dates(~cellfun(@(x) isnumeric(x) || islogical(x), dates)) = {NaN};
tableout.VarName3 = datetime([dates{:,1}].', 'ConvertFrom', 'Excel');
tableout.VarName4 = data(:,2);
tableout.VarName5 = data(:,3);
tableout.VarName6 = data(:,4);
tableout.SD = data(:,5);
tableout.CPK = data(:,6);
tableout.VarName9 = data(:,7);
tableout.VarName10 = stringVectors(:,2);
tableout.VarName11 = categorical(stringVectors(:,3));
tableout.VarName12 = categorical(stringVectors(:,4));

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% tableout.VarName3=datenum(tableout.VarName3);

```

成功提取之后，将其保存为`.matlab`文件，方便之后的读取，从此就可以摆脱excel，直接在Matlab上面进行数据处理了。

### 1.2. 过程检验数据的提取

过程检验的数据分为叶片过程检验数据和叶丝过程检验数据。需要分别进行提取。这个过程中变量少，所以提取需要花的时间并不多。

利用同样的方法，对检验数据进行提取。



由于数据量大，整个数据提取过程耗费了较多时间（约几十分钟），可能是算法方面的问题。从这方面也可以看出，数据量庞大的时候一个优秀的算法的重要性。

### 1.3. 检验数据并生成.matlab文件保存

采用Matlab中数据和excel文档中数据抽查比对的方式确定数据提取的准确性。经过检查比对，数据无误，可以保存。

保存之后，将过程中使用的算法以及生成的`stats.matlab`文档使用`Git` 加入Version Control，然后上传至GitHub。

最后，因为数据需要保密的原因，具体提取出来的数据以及excel原文档不会上传到GitHub中。



### 1.4. 数据格式内容备注

由于MATLAB中`cell`类型的数据占内存太大，我的PC机不能处理，所以使用`table`类型的数据。因为matlab中不支持中文作为列名，所以在列名分别为：

1. 在生产过程统计数据中

   | 序号   | 工单号    | 日期 | 最大值 | 最小值 | 平均值  | SD   | CPK  | 置信值     | 参数    | 工艺段  | 牌号     |
   | ------ | --------- | ---- | ------ | ------ | ------- | ---- | ---- | ---------- | ------- | ------- | -------- |
   | Number | Workorder | Date | Max    | Min    | Average | SD   | CPK  | Confidence | Varname | Segment | Category |

2. 在叶片和叶丝检验数据中：

   | 检验项目  | 序号   | 检验值 | 录入时间 | 生产工单号 | 生产批次号      | 物料     |
   | --------- | ------ | ------ | -------- | ---------- | --------------- | -------- |
   | undefined | Number | Value  | Time     | Workorder  | Productionorder | Category |

特此记录，以备后用。



# 2018.4.25 把提取的数据进行预处理

数据量比较多，优先提取15年7月的出软长嘴。提取的方法：



首先，通过对excel文件的研究，发现如下规律：一次加料，二次加料，



# 2018.4.26 预处理MATLAB代码的编写

首先，尝试使用自己编的函数来遍历。最后发现效率太低，遂学习MATLAB自带函数，尝试使用它的函数来进行编程，同时学习table数据变量的用法。

## 1. excel文件的熟悉

假设原`1 生产过程统计数据`的工单号是连续的（即中间没有断开）（事实上检测了数个工单，并没有发现太大违背假设的情况，以后如果出现例外，再进行处理），继续进行处理。

在研究`1 生产过程统计数据`之后，发现不同工单号对应的检测变量并没有特定的规律。具体体现在：

> 有的一次加料34个变量，有的一次加料一次加料52个变量，有的一次加料40个变量，变量个数完全不统一


目前的解决做法是，列出所有可以检测的变量（17年1月），生成一个`string array`类型存放 `1 - ?`  所对应的变量。然后进行数据提取到另一个table的环节的时候，按照`string array`表的对应关系，一个批次号一个批次号地填入。

如何找到所有的变量？利用MATLAB内部的去重函数`unique`，统计有多少个对应的变量。`unique`函数会自动帮我们把对应的`string array`排序。





# 参考文档：

1. [MATLAB official document - table2cell](https://ww2.mathworks.cn/help/matlab/ref/table2cell.html)
2. [MATLAB新的统计数据类型Table](https://blog.csdn.net/rumswell/article/details/49401913)
3. [MATLAB official documentation - table](https://ww2.mathworks.cn/help/matlab/matlab_prog/create-a-table.html)
4. [MATLAB table常用操作](http://www.ilovematlab.cn/article-53-1.html#table_find)
5. ​



# 下周计划

由于下周考试周即将来临，所以下周的暂时不定计划。可能会有项目的执行，具体参考下周的周报。