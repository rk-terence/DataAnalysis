%% 提取生产过程的数据
filename = "StatisticsInProduction.xlsx";
for i = 1:24
    sheetname = GenSheetname(i);
    xls = xlsread(filename,sheetname);
    endrow = length(xls) + 1;
    if i <= 6
        varname = "15" + string(i + 6);            
    else
        if i <= 18
            varname = "16" + string(i - 6);
        else
            varname = "17" + string(i - 18);
        end
    end
    eval('raw_' + varname + ' = ' + 'importfilefromexcel(filename, sheetname, 2, endrow);');
end

% 更改列名称
for i = 1:24
    if i <= 6
        varname = "15" + string(i + 6);            
    else
        if i <= 18
            varname = "16" + string(i - 6);
        else
            varname = "17" + string(i - 18);
        end
    end
    eval('raw_' + varname + ".Properties.VariableNames = {'Number', 'Workorder', 'Date', 'Max', 'Min', 'Average', 'SD', 'CPK', 'Confidence', 'Varname', 'Segment', 'Category'};");
end 

%% 提取制叶段的测试结果
filename = "LeafTest.xlsx";

xls = xlsread(filename,"大片率");
endrow = length(xls) + 2;
raw_bigleaf = importfilefromexcel2(filename, "大片率", 3, endrow);

xls = xlsread(filename,"中片率");
endrow = length(xls) + 2;
raw_midleaf = importfilefromexcel2(filename, "中片率", 3, endrow);

xls = xlsread(filename,"大中片率");
endrow = length(xls) + 2;
raw_bmleaf = importfilefromexcel2(filename, "大中片率", 3, endrow);

xls = xlsread(filename,"碎片率");
endrow = length(xls) + 2;
raw_brokenleaf = importfilefromexcel2(filename, "碎片率", 3, endrow);

%更改列名称
raw_bigleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_bmleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_brokenleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

%% 提取制丝段的测试结果
filename = "CuttobaccoTest.xlsx";

xls = xlsread(filename, "长丝率");
endrow = length(xls) + 2;
raw_longsi = importfilefromexcel3(filename, "长丝率", 3, endrow);

xls = xlsread(filename, "短丝率");
endrow = length(xls) + 2;
raw_shortsi = importfilefromexcel3(filename, "短丝率", 3, endrow);

xls = xlsread(filename, "中丝率");
endrow = length(xls) + 2;
raw_midsi = importfilefromexcel3(filename, "中丝率", 3, endrow);

xls = xlsread(filename, "整丝率");
endrow = length(xls) + 2;
raw_completesi = importfilefromexcel3(filename, "整丝率", 3, endrow);

xls = xlsread(filename, "碎丝率");
endrow = length(xls) + 2;
raw_brokensi = importfilefromexcel3(filename, "碎丝率", 3, endrow);

xls = xlsread(filename, "填充值");
endrow = length(xls) + 2;
raw_fillsi = importfilefromexcel3(filename, "填充值", 3, endrow);


%更改列名称
raw_fillsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_longsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_shortsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_completesi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_brokensi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

