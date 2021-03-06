function [xy_table, vars] = getXY(monthyear, category, prod_line, ...
    output_kind, value_kind)
% @brief: get the XY table of all production orders in the specified range
% of time.
% @param monthyear: A 2-by-1 string array. Example: ["201701"; "201711"]
% @param category: The category of a specific kind of cigarette. Example:
% "���쳤��".
% @param prod_line: the production line of the cigarette. Example: 'A',
% Note: A+E, B+D, C+F.
% @param output_kind: to choose the output kind. 0 means leaf period, 1
% means si period and 2 means the whole period (All production variables
% and all test variables
% @param value_kind: 0 - average value; 1 - variance value
% @return xy_table: XY table
% @return vars: The name of vars in production that has the same order as
% xy_table.
% @author: Terence Email: rkterence@zju.edu.cn
%
% Related sub-functions: getHeader.m, getProductions.m,
% getYearAndMonth.m. They are all called by this function.
%
% Version: 1.0. This version is published since Dec. 4th, 2018.
%
% Complexity of this algorithm in MATLAB:
% several input kinds have been tested, and the result is acceptable, with
% one of the most complex input (mode 2, and all months of data of category
% ���쳤��) costing about 5 mins on my laptop.
%
% NOTE: All functions of this script function has been tested, and
% they have all passed the testing. The next version of this function will
% fix the little bugs shown below, which is not considered primary now:
%
% 1. Add productionorder info while subtracting from raw_data to avoid
% other production line variables being added to the chosen prodline.
% (Maybe through adding new column of productionorder info to raw_data, or,
% say, StatisticsInProduction.xlsx.
% 
% 
% Version: 1.1. This version is published since Dec. 11th, 2018.
%
% Bug fixed! Now unnecessary entries of raw_data will be deleted before the
% computation of the amount of features during production. To achieve this,
% I changed the original data format:
% By a script file named AddProductionOrderToStatisticsInProduction.m, I
% added an extra column of raw_data, which gives us the info of production
% order of that workorder. Then, the new data is saved in the name of
% raw_stats_delta.mat. So there will only be small changes in this script
% function, one of which is the name of file to load, and the other is some
% logics to delete the rows that is not necessary in raw_data (judged by
% prod_line and category).
% Through some rough checks, there will be no cols that have actually no
% valid elements.



%-------------------------------------------------------------------------------
% Load the latest preprocessed dataset:
%-------------------------------------------------------------------------------    
% Load the relationship data and testing data
load ..\data_and_files\raw_stats_delta.mat ...
relationship_charlie raw_fillsi raw_longsi raw_midsi raw_shortsi ...
raw_brokensi raw_completesi raw_bigleaf raw_bmleaf raw_midleaf raw_brokenleaf

% Load the data in production
[start_year, start_month, end_year, end_month] = getYearAndMonth ...
    (monthyear);
delta_month = end_year*12+end_month - start_year*12 - start_month;
month = start_month; year = start_year;
raw_data = table;
for i=0:delta_month
    eval("load ..\data_and_files\raw_stats_delta.mat" + " raw_" ...
        + string(year) + string(month))
    eval("raw_data = [raw_data; " + "raw_" + string(year) + string(month)+"];")
    eval("clear raw_"+string(year) + string(month))
    month = month + 1;
    if month > 12
        year = year + 1;
        month = 1;
    end
end

% Load the important variable names
[~, zhiye_vars, ~] = xlsread('../data_and_files/zhiye_variables_new.xlsx');
zhiye_vars = string(zhiye_vars);
[~, zhisi_vars, ~] = xlsread('../data_and_files/zhisi_variables_new.xlsx');
zhisi_vars = string(zhisi_vars);


%-------------------------------------------------------------------------------
% Get the production orders
%-------------------------------------------------------------------------------
% To get the production orders in the month year range:
[productions, category_ex] = getProductions(relationship_charlie, monthyear, ...
    category, prod_line, output_kind);

%-------------------------------------------------------------------------------
% Get the xy_table:
%-------------------------------------------------------------------------------
% Get the number of production orders and variable names.
num_prod = length(productions.Number);
% Delete other production lines in raw_data
po_array_raw = char(raw_data.Productionorder);
po_array_raw = po_array_raw(:, 9);
raw_data(po_array_raw ~= prod_line, :) = [];
% Delete other categories in raw_data
if output_kind == 2
    raw_data(logical((string(raw_data.Category) ~= category_ex(1)) .* ...
        (string(raw_data.Category) ~= category_ex(2))), :) = [];
    % Below I use the remaining raw_data to get the variable names of each
    % production period. In my view, this is important in the process of
    % data.
    
    % part of the remaining rawdata which matches zhiye period.
    raw_data_copy_zhiye = [raw_data(string(raw_data.Category) == ...
        category_ex(1), :)];
    vars_zhiye = sort(unique(raw_data_copy_zhiye.Varname)); % Vars of zhiye
    xlswrite('zhiye_vars.xlsx', vars_zhiye);
    % part of the remaining rawdata which matches zhisi period.
    raw_data_copy_zhisi = [raw_data(string(raw_data.Category) == ...
        category_ex(2), :)];
    vars_zhisi = sort(unique(raw_data_copy_zhisi.Varname)); % Vars of zhisi
    xlswrite('zhisi_vars.xlsx', vars_zhisi);
else
    raw_data(string(raw_data.Category) ~= category_ex, :) = [];
end
% Get the name of vars in the remaining raw_data
switch output_kind
    case 0
        vars = sort(zhiye_vars);
    case 1
        vars = sort(zhisi_vars);
    case 2
        vars = string([zhiye_vars; zhisi_vars]);
end
% The method below is legacy method, for bringing in unnecessary vars.
% vars = sort(unique(raw_data.Varname));
num_vars = length(vars);

% get the header of the table
[header, row_vector_default] = getHeader(output_kind, num_vars);

xy_table = cell(0,0);
% Expand xy_table dynamically:
i = 1;
while i <= num_prod
    productionorder = productions.Productionorder(i);
    workorders = productions.Workorder(i);
    while i < num_prod && productions.Productionorder(i+1) == productionorder
        workorders = [workorders; productions.Workorder(i+1)];
        i = i + 1;
    end
    row_value = []; row_variable = [];
    for k = 1:length(workorders)
        if value_kind
            row_value = [row_value;
                raw_data.SD(raw_data.Workorder == workorders(k))];
        else
            row_value = [row_value;
                raw_data.Average(raw_data.Workorder == workorders(k))];
        end
        row_variable = [row_variable;
            raw_data.Varname(raw_data.Workorder == workorders(k))];
    end
    % Get the intersect of vars
    [row_variable, ~, index_row_variable] = intersect(vars, row_variable);
    row_value = row_value(index_row_variable);
    num_row_variable = length(row_variable);
    row_vector = row_vector_default;    
    
    % stats in production
    for j = 1:num_row_variable
        row_vector{vars == row_variable(j)} = row_value(j);
    end
    % stats in testing
    switch output_kind
        case 0
            row_vector{end-6} = mean(raw_bigleaf.Value( ...
                raw_bigleaf.Productionorder == productionorder));
            row_vector{end-5} = mean(raw_bmleaf.Value( ...
                raw_bmleaf.Productionorder == productionorder));
            row_vector{end-4} = mean(raw_midleaf.Value( ...
                raw_midleaf.Productionorder == productionorder));
            row_vector{end-3} = mean(raw_brokenleaf.Value( ...
                raw_brokenleaf.Productionorder == productionorder));
        case 1
            row_vector{end-8} = mean(raw_fillsi.Value( ...
                raw_fillsi.Productionorder == productionorder));
            row_vector{end-7} = mean(raw_longsi.Value( ...
                raw_longsi.Productionorder == productionorder));
            row_vector{end-6} = mean(raw_midsi.Value( ...
                raw_midsi.Productionorder == productionorder));
            row_vector{end-5} = mean(raw_shortsi.Value( ...
                raw_shortsi.Productionorder == productionorder));
            row_vector{end-4} = mean(raw_brokensi.Value( ...
                raw_brokensi.Productionorder == productionorder));
            row_vector{end-3} = mean(raw_completesi.Value( ...
                raw_completesi.Productionorder == productionorder));
        case 2
            row_vector{end-12} = mean(raw_bigleaf.Value( ...
                raw_bigleaf.Productionorder == productionorder));
            row_vector{end-11} = mean(raw_bmleaf.Value( ...
                raw_bmleaf.Productionorder == productionorder));
            row_vector{end-10} = mean(raw_midleaf.Value( ...
                raw_midleaf.Productionorder == productionorder));
            row_vector{end-9} = mean(raw_brokenleaf.Value( ...
                raw_brokenleaf.Productionorder == productionorder));
            row_vector{end-8} = mean(raw_fillsi.Value( ...
                raw_fillsi.Productionorder == productionorder));
            row_vector{end-7} = mean(raw_longsi.Value( ...
                raw_longsi.Productionorder == productionorder));
            row_vector{end-6} = mean(raw_midsi.Value( ...
                raw_midsi.Productionorder == productionorder));
            row_vector{end-5} = mean(raw_shortsi.Value( ...
                raw_shortsi.Productionorder == productionorder));
            row_vector{end-4} = mean(raw_brokensi.Value( ...
                raw_brokensi.Productionorder == productionorder));
            row_vector{end-3} = mean(raw_completesi.Value( ...
                raw_completesi.Productionorder == productionorder));
    end
    % info stats
    row_vector{end-2} = workorders(1);
    row_vector{end-1} = productionorder;
    row_vector{end} = category;
    % expand the xy_table
    xy_table = [xy_table; row_vector];
    
    i = i + 1;
end
xy_table = cell2table(xy_table, 'VariableNames', header);
vars = vars';



function [Header, row_vector_default] = getHeader(output_kind, n_vars)
switch output_kind
    case 0
        Header = cell(1, n_vars + 7);
        row_vector_default = cell(1, n_vars + 7);
        for i = 1:n_vars
            Header{i} = char("Var" + string(i));
        end
        Header{n_vars+1} = 'Bigleaf';
        Header{n_vars+2} = 'Bmleaf';
        Header{n_vars+3} = 'Midleaf';
        Header{n_vars+4} = 'Brokenleaf';
        Header{n_vars+5} = 'Workorder';
        Header{n_vars+6} = 'Productionorder';
        Header{n_vars+7} = 'Category';
    case 1
        Header = cell(1, n_vars+9);
        row_vector_default = cell(1, n_vars + 9);
        for i=1:n_vars
            Header{i} = char("Var" + string(i));
        end
        Header{n_vars+1} = 'Fillsi';
        Header{n_vars+2} = 'Longsi';
        Header{n_vars+3} = 'Midsi';
        Header{n_vars+4} = 'Shortsi';
        Header{n_vars+5} = 'Brokensi';
        Header{n_vars+6} = 'Completesi';
        Header{n_vars+7} = 'Workorder';
        Header{n_vars+8} = 'Productionorder';
        Header{n_vars+9} = 'Category';
    case 2
        Header = cell(1, n_vars + 13);
        row_vector_default = cell(1, n_vars + 13);
        for i=1:n_vars
            Header{i} = char("Var" + string(i));
        end
        Header{n_vars+1} = 'Bigleaf';
        Header{n_vars+2} = 'Bmleaf';
        Header{n_vars+3} = 'Midleaf';
        Header{n_vars+4} = 'Brokenleaf';
        Header{n_vars+5} = 'Fillsi';
        Header{n_vars+6} = 'Longsi';
        Header{n_vars+7} = 'Midsi';
        Header{n_vars+8} = 'Shortsi';
        Header{n_vars+9} = 'Brokensi';
        Header{n_vars+10} = 'Completesi';
        Header{n_vars+11} = 'Workorder';
        Header{n_vars+12} = 'Productionorder';
        Header{n_vars+13} = 'Category';
end



function [productions, category] = getProductions(relationship_charlie, ...
    monthyear, category, prod_line, output_kind)

% To get the production orders in the month year range:
monthyear_array = char(relationship_charlie.Productionorder);
monthyear_array = string(monthyear_array(:,1:6));
startrow = find(monthyear(1) == monthyear_array, 1, 'first');
endrow = find(monthyear(2) == monthyear_array, 1, 'last');
productions = relationship_charlie(startrow:endrow, :);
% Delete other production lines
prod_line_array = char(productions.Productionorder);
prod_line_array = prod_line_array(:, 9);
productions(prod_line_array ~= prod_line, :) = []; 
% Delete other categories
switch output_kind
    case 0
        category = "��Ⱥ(" + category + ")ҶƬ";
        productions(string(productions.Category) ~= category,:) = [];
    case 1
        category = "��Ⱥ��" + category + "��Ҷ˿";
        productions(string(productions.Category) ~= category,:) = [];
    case 2
        category = ["��Ⱥ(" + category + ")ҶƬ"; "��Ⱥ��" + category + ...
            "��Ҷ˿"];
        productions=productions(logical((string(productions.Category)== ... 
            category(1)) + (string(productions.Category) == category(2))), :);
    otherwise
        error("Wrong input of output_kind");
end



function [start_year, start_month, end_year, end_month] = getYearAndMonth ...
    (monthyear)

start_monthyear = char(monthyear(1));
if start_monthyear(5) == '0'
    start_month = start_monthyear(6) - '0';
else
    start_month = start_monthyear(6) - '0' + 10;
end
start_year = 15 + start_monthyear(4) - '5';

end_monthyear = char(monthyear(2));
if end_monthyear(5) == '0'
    end_month = end_monthyear(6) - '0';
else
    end_month = end_monthyear(6) - '0' + 10;
end
end_year = 15 + end_monthyear(4) - '5';