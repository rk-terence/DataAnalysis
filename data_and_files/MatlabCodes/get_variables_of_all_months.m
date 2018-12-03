variables = cell(24,1);
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
    eval('variable' + string(i) + '=unique(raw_' + varname + '.Varname);')
    eval('variables{i} = variable' + string(i) + ';');
end