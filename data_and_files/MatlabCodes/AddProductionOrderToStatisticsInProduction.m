% Prerequization: raw_data_charlie.mat
clear
load ..\data_and_files\raw_stats_charlie.mat

for i = 1:24
    if i <= 6
        yearmonth = "15" + string(i + 6);            
    else
        if i <= 18
            yearmonth = "16" + string(i - 6);
        else
            yearmonth = "17" + string(i - 18);
        end 
    end
    eval("raw_" + yearmonth + "=addProductionOrder(raw_" + yearmonth + ...
        ",relationship_charlie);");
end


function raw_data = addProductionOrder(raw_data, relationship_charlie)
h = height(raw_data);
prod_col = strings(h, 1);
for i = 1:h
    po = string(relationship_charlie.Productionorder(find( ...
        relationship_charlie.Workorder==string(raw_data.Workorder(i)), ...
        1, 'first')));
    if ~isempty(po)
        prod_col(i) = po;
    end
end
raw_data.Productionorder = prod_col;
end
