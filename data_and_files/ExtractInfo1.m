filename = "data_and_files\StatisticsInProduction.xlsx";

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
