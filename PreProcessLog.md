# 2018.4.24

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

#### 1.2.1. 叶片过程检验数据



#### 1.2.2. 叶丝过程检验数据
