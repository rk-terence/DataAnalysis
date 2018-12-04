function [xy_table, vars] = getXY(monthyear, category, prod_line, output_kind)
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
% fix the little bugs shown above, which is not considered primary now:
% 1. Add productionorder info while subtracting from raw_data to avoid
% other production line variables being added to the chosen prodline.
% (Maybe through adding new column of productionorder info to raw_data, or,
% say, StatisticsInProduction.xlsx.



%-------------------------------------------------------------------------------
% Load the latest preprocessed dataset:
%-------------------------------------------------------------------------------
% Load the relationship data and testing data
load ..\data_and_files\raw_stats_charlie.mat ...
relationship_charlie raw_fillsi raw_longsi raw_midsi raw_shortsi ...
raw_brokensi raw_completesi raw_bigleaf raw_bmleaf raw_midleaf raw_brokenleaf

% Load the data in production
[start_year, start_month, end_year, end_month] = getYearAndMonth ...
    (monthyear);
delta_month = end_year*12+end_month - start_year*12 - start_month;
month = start_month; year = start_year;
raw_data = table;
for i=0:delta_month
    eval("load ..\data_and_files\raw_stats_charlie.mat" + " raw_" ...
        + string(year) + string(month))
    eval("raw_data = [raw_data; " + "raw_" + string(year) + string(month)+"];")
    eval("clear raw_"+string(year) + string(month))
    month = month + 1;
    if month > 12
        year = year + 1;
        month = 1;
    end
end

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
if output_kind == 2
    vars = sort(unique(raw_data.Varname(logical((string(raw_data.Category) ... 
        == category_ex(1)) + (string(raw_data.Category) == category_ex(2))))));
else
    vars = sort(unique(raw_data.Varname(string(raw_data.Category) ...
    == category_ex)));
end
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
        row_value = [row_value;
            raw_data.Average(raw_data.Workorder == workorders(k))];
        row_variable = [row_variable;
            raw_data.Varname(raw_data.Workorder == workorders(k))];
    end
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