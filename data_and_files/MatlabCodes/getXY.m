function [xy_table, vars] = getXY(monthyear, category, prod_line, output_kind)
% @brief: get the XY table of all production orders in the specified range
% of time.
% @param monthyear: A 2-by-1 string array. Example: ["201701"; "201711"]
% @param category: The category of a specific kind of cigarette. Example:
% "Èíºì³¤×ì".
% @param prod_line: the production line of the cigarette. Example: 'A'
% @param output_kind: to choose the output kind. 0 means leaf period, 1
% means si period and 2 means the whole period (All production variables
% and all test variables
% @return xy_table: XY table
% @return vars: The name of vars in production that has the same order as
% xy_table.
%
% NOTE: this script is in beta stage, but no overall testing has been made.


%% Load the latest preprocessed dataset:
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
disp("finished data loading")

%% Get the production orders
% To get the production orders in the month year range:
[productions, category_ex] = getProductions(relationship_charlie, monthyear, ...
    category, prod_line, output_kind);

% ------------------------------------------------------------------------------
% The code above has been successfully tested by input: 
% getXY(["201510";"201602"], "Èíºì³¤×ì", 'A', 1)
% ------------------------------------------------------------------------------

%% Get the xy_table:
% Get the number of production orders and variable names.
num_prod = length(productions.Number);
if input_kind ~= 2
    vars = sort(unique(raw_data.Varname(string(rawdata.Category) == category_ex(1) ...
        + string(raw_data.Category) == category_ex(2))));
else
    vars = sort(unique(raw_data.Varname(string(rawdata.Category) ...
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
    while productions.Productionorder(i+1) == productionorder
        workorders = [workorders; productions.Workorder(i+1)];
        i = i + 1;
    end
    row_value = []; row_variable = [];
    for k = 1:length(workorders)
        row_value = [row_value;
            raw_data.Average(raw_data.Workorder == row_workorder(k))];
        row_variable = [row_variable;
            raw_data.Varname(raw_data.Workorder == row_workorder(k))];
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
    row_vector{end-1} = pruductionorder;
    row_vector{end} = category;
    % expand the xy_table
    xy_table = [xy_table; row_vector];
    
    i = i + 1;
end
xy_table = cell2table(xy_table, 'VariableNames', header);
vars = vars';
