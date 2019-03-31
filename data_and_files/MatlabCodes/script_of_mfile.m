%% Data Extracting 
[xy_table_average, vars] = getXY(["201507";"201706"], "Èíºì³¤×ì", 'C', 2, 0);

%% Delete columns that have more than 15 nans
num_nan_col = [];
for i = 1:width(xy_table_average(:, 1:end-13))
    feature = xy_table_average{:, i};
    num_nan_col = [num_nan_col; height(xy_table_average) - length(cell2mat(feature))];
end
num_nan_row = [];
for i = 1:height(xy_table_average)
    sample = xy_table_average{i, 1:end-13};
    num_nan_row = [num_nan_row; width(xy_table_average(:, 1:end-13)) ...
        - length(cell2mat(sample))];
end
vars(num_nan_col >= 15) = [];
xy_table_average(:, num_nan_col >= 15) = [];

%% Delete rows that have nans
num_nan_row_after = [];
for i = 1:height(xy_table_average)
    sample = xy_table_average{i, 1:end-13};
    num_nan_row_after = [num_nan_row_after; width(xy_table_average(:, 1:end-13)) ...
        - length(cell2mat(sample))];
end
xy_table_average(num_nan_row_after > 0, :) = [];

%% Output
xy_table_average(:, [end-2, end-1, end]) = [];
writetable(xy_table_average, '..\data_and_files\Build\RHC_C+F_zhiyezhisi_new.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\RHC_C+F_zhiyezhisi_new_vars.xlsx', vars);