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

xls = xlsread(filename,"��Ƭ��");
endrow = length(xls) + 2;
raw_bigleaf = importfilefromexcel2(filename, "��Ƭ��", 3, endrow);

xls = xlsread(filename,"��Ƭ��");
endrow = length(xls) + 2;
raw_midleaf = importfilefromexcel2(filename, "��Ƭ��", 3, endrow);

xls = xlsread(filename,"����Ƭ��");
endrow = length(xls) + 2;
raw_bmleaf = importfilefromexcel2(filename, "����Ƭ��", 3, endrow);

xls = xlsread(filename,"��Ƭ��");
endrow = length(xls) + 2;
raw_brokenleaf = importfilefromexcel2(filename, "��Ƭ��", 3, endrow);


%Read the information of test statistics of Cut tobaccos.
filename = "CuttobaccoTest.xlsx";

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_longsi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_shortsi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_midsi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_completesi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_brokensi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "���ֵ��Y��");
endrow = length(xls) + 2;
raw_fillsi = importfilefromexcel3(filename, "���ֵ��Y��", 3, endrow);
