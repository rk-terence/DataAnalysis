% Read the information of the statistics in production
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
    eval('raw_' + varname + ' = ' + 'importfilefromexcel1(filename, sheetname, 2, endrow);');
end

%Read the information of test statistics of Leaves.
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


%Read the information of test statistics of Cut tobaccos.
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

xls = xlsread(filename, "填充值（Y）");
endrow = length(xls) + 2;
raw_fillsi = importfilefromexcel3(filename, "填充值（Y）", 3, endrow);
