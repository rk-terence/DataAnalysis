function [XY_stats, Varnames] = PreProcessData_Charlie(month, year, category)

%% To import the latest dataset:
load raw_stats_charlie.mat relationship_charlie raw_fillsi raw_longsi raw_midsi raw_shortsi raw_brokensi raw_completesi raw_bigleaf raw_bmleaf raw_midleaf raw_brokenleaf;
yearmonth = string(year)+string(month);
eval("load raw_stats_charlie.mat raw_"+yearmonth);
eval("rawdata = raw_"+yearmonth+';');
eval("clear raw_"+yearmonth);

%% To get the production orders of the specific month
% Transform po_array into a [string array] with only year and month
po_array = char(relationship_charlie.Productionorder);
po_array = string(po_array(:,1:6));
% form the identifier of this year
if month <= 9
    po_array_identifier = "20" + string(year) + "0" + string(month);
else
    po_array_identifier = "20" + string(year) + string(month);
end
% Search from the production orders
ProductionThisMonth = relationship_charlie(po_array == po_array_identifier, :);

%% One step ahead, to get the production orders of the specific category
% Delete other categories
ProductionThisMonth(string(ProductionThisMonth.Category) ~= category,:) = [];
num_production = length(ProductionThisMonth.Number);
%% Initalize the output (xy_stats and Varnames)
% If no error is displayed, continue. Otherwise the result is not
% convincible.
% Error detected. Thus the variables can vary. The assumption is false.
% -----------------------------------------------------------------------------
% for i=1:length(ProductionThisMonth.Workorder)
%     if isempty(Varnames)
%         Varnames = sort(rawdata.Varname(rawdata.Workorder == ProductionThisMonth.Workorder(i)));
%     end
%     Varnames1 = sort(rawdata.Varname(rawdata.Workorder == ProductionThisMonth.Workorder(i)));
%     if(Varnames1 ~= Varnames)
%         disp("Variables are not the same!")
%     end
% end

% Get all the related variables of this month
Varnames = sort(unique(rawdata.Varname(string(rawdata.Category) == category)));
n_vars = length(Varnames);  % The number of variables during production.
% Define the Header of the Table.
category_char = char(category);
if strcmp(category_char(end-1:end),'Ҷ˿')
    Header = cell(1, n_vars+9);
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
    % The container of each row:
    % The default value of cell is empty matrix, so that there is no need
    % to fill it with nan.
    row_vector_default = cell(1, n_vars+9);
else
    Header = cell(1, n_vars + 7);
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
    % The container of each row:
    row_vector_default = cell(1, n_vars+7);
end

% Initialize the output table(here in the form of cell, to make use of the
% dynamic characteristic of cell so that the table can be changing size
% dynamically.
XY_stats = cell(0,0);
% GET THE SPECIFIC ROW:
for i=1:num_production
    row_workorder = ProductionThisMonth.Workorder(i);
    row_value = rawdata.Average(rawdata.Workorder == row_workorder);
    row_variable = rawdata.Varname(rawdata.Workorder == row_workorder);
    num_row_variable = length(row_variable);
    row_vector = row_vector_default;
    
    for j = 1:num_row_variable
        row_vector{Varnames == row_variable(j)} = row_value(j);
    end
    XY_stats = [XY_stats; row_vector];
end
XY_stats = cell2table(XY_stats, 'VariableNames', Header);
Varnames = Varnames';