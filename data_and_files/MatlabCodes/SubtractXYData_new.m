clear
% Data Extracting 
[xy_table_zhiyezhisi, vars_zhiyezhisi] = ...
    getXY(["201507";"201706"], "Èíºì³¤×ì", 'C', 2, 0);
[xy_table_zhiye, vars_zhiye] = getXY(["201507";"201706"], "Èíºì³¤×ì", 'C', 0, 0);
[xy_table_zhisi, vars_zhisi] = getXY(["201507";"201706"], "Èíºì³¤×ì", 'C', 1, 0);

% Dealing with nans
[xy_table_zhiyezhisi, vars_zhiyezhisi] = dealWithNan(xy_table_zhiyezhisi, ...
                                                     vars_zhiyezhisi, 13);
[xy_table_zhiye, vars_zhiye] = dealWithNan(xy_table_zhiye, vars_zhiye, 7);
[xy_table_zhisi, vars_zhisi] = dealWithNan(xy_table_zhisi, vars_zhisi, 9);

% Output
xy_table_zhiyezhisi(:, [end-2, end-1, end]) = [];
writetable(xy_table_zhiyezhisi, ...
    '..\data_and_files\Build\RHC_C+F_zhiyezhisi_new.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\RHC_C+F_zhiyezhisi_new_vars.xlsx', vars_zhiyezhisi);

xy_table_zhiye(:, [end-2, end-1, end]) = [];
writetable(xy_table_zhiye, ...
    '..\data_and_files\Build\RHC_C+F_zhiye_new.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\RHC_C+F_zhiye_new_vars.xlsx', vars_zhiye);

xy_table_zhisi(:, [end-2, end-1, end]) = [];
writetable(xy_table_zhisi, ...
    '..\data_and_files\Build\RHC_C+F_zhisi_new.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\RHC_C+F_zhisi_new_vars.xlsx', vars_zhisi);


function [xy_table, vars] = dealWithNan(xy_table, vars, offset)
xy_table_cell_copy = table2cell(xy_table);
% Delete columns that have more than 15 nans
num_nan_col = [];
for i = 1:width(xy_table(:, 1:end-offset))
    feature = xy_table_cell_copy(:, i);
    num_nan_col = [num_nan_col; height(xy_table) - length(cell2mat(feature))];
end
num_nan_row = [];
for i = 1:height(xy_table)
    sample = xy_table_cell_copy(i, 1:end-offset);
    num_nan_row = [num_nan_row; width(xy_table(:, 1:end-offset)) ...
                                - length(cell2mat(sample))];
end
vars(num_nan_col >= 15) = [];
xy_table(:, num_nan_col >= 15) = [];
xy_table_cell_copy(:, num_nan_col >= 15) = [];

% Delete rows that have nans
num_nan_row_after = [];
for i = 1:height(xy_table)
    sample = xy_table_cell_copy(i, 1:end-offset);
    num_nan_row_after = [num_nan_row_after; width(xy_table(:, 1:end-offset)) ...
        - length(cell2mat(sample))];
end
xy_table(num_nan_row_after > 0, :) = [];
end