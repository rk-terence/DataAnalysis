%% ��ȡ�������̵�����
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

% ����������
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

%% ��ȡ��Ҷ�εĲ��Խ��
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

%����������
raw_bigleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_bmleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_brokenleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

%% ��ȡ��˿�εĲ��Խ��
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

xls = xlsread(filename, "���ֵ");
endrow = length(xls) + 2;
raw_fillsi = importfilefromexcel3(filename, "���ֵ", 3, endrow);


%����������
raw_fillsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_longsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_shortsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_completesi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_brokensi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

