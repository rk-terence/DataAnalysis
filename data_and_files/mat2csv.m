clear
load preprocessed_data.mat

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
    %eval("xy_stats"+varname+"=table2array(xy_stats"+varname+"(:,3:end));");
    %eval("csvwrite('xy_stats"+varname+".csv', xy_stats"+varname+");");
    eval("xlswrite('variables"+varname+".xlsx', variables"+varname+");");
    %eval("clearvars raw_"+varname);
end