clear
%% 软红长嘴相关处理（目前是所有月份）
% 制叶+制丝段数据：
[xy_table, vars] = getXY(["201507";"201706"], "软红长嘴", 'C', 2);
writetable(xy_table, '..\data_and_files\Build\软红长嘴（C+F线）制叶+制丝数据.xlsx');
% CSV数据和xlsx数据不同，不要最后三列信息，同时也不要表头
xy_table(:, [end-2, end-1, end]) = [];
writetable(xy_table, '..\data_and_files\Build\软红长嘴（C+F线）制叶+制丝数据.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\软红长嘴（C+F线）制叶+制丝对应变量.xlsx', vars);
% 制叶段数据：
[xy_table, vars] = getXY(["201507";"201706"], "软红长嘴", 'C', 0);
writetable(xy_table, '..\data_and_files\Build\软红长嘴（C+F线）制叶数据.xlsx');
xy_table(:, [end-2, end-1, end]) = [];
writetable(xy_table, '..\data_and_files\Build\软红长嘴（C+F线）制叶数据.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\软红长嘴（C+F线）制叶对应变量.xlsx', vars);
% 制丝段数据：
[xy_table, vars] = getXY(["201507";"201706"], "软红长嘴", 'C', 1);
writetable(xy_table, '..\data_and_files\Build\软红长嘴（C+F线）制丝数据.xlsx');
xy_table(:, [end-2, end-1, end]) = [];
writetable(xy_table, '..\data_and_files\Build\软红长嘴（C+F线）制丝数据.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\软红长嘴（C+F线）制丝对应变量.xlsx', vars);

%% 软长嘴相关处理（目前是所有月份）
% 制叶+制丝段数据：
% [xy_table, vars] = getXY(["201507";"201706"], "软红长嘴", 'C', 2);