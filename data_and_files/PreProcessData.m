load raw_stats.mat
for i = 1:24
    if i <= 6
        varname = "15" + string(i + 6);
        year = 15;
        month = 6 + i;
    else
        if i <= 18
            varname = "16" + string(i - 6);
            year = 16;
            month = i - 6;
        else
            varname = "17" + string(i - 18);
            year = 17;
            month = i - 18;
        end
    end
    eval("[xy_stats"+varname+",variables"+varname+"]=PreProcessData_Beta_UTF8(month,year,raw_"+varname+");");
    eval("clearvars raw_"+varname);
end