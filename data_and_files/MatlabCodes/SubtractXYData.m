clear
%% ��쳤����ش���Ŀǰ�������·ݣ�
% ��Ҷ+��˿�����ݣ�
[xy_table, vars] = getXY(["201507";"201706"], "��쳤��", 'C', 2);
writetable(xy_table, '..\data_and_files\Build\��쳤�죨C+F�ߣ���Ҷ+��˿����.xlsx');
% CSV���ݺ�xlsx���ݲ�ͬ����Ҫ���������Ϣ��ͬʱҲ��Ҫ��ͷ
xy_table(:, [end-2, end-1, end]) = [];
writetable(xy_table, '..\data_and_files\Build\��쳤�죨C+F�ߣ���Ҷ+��˿����.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\��쳤�죨C+F�ߣ���Ҷ+��˿��Ӧ����.xlsx', vars);
% ��Ҷ�����ݣ�
[xy_table, vars] = getXY(["201507";"201706"], "��쳤��", 'C', 0);
writetable(xy_table, '..\data_and_files\Build\��쳤�죨C+F�ߣ���Ҷ����.xlsx');
xy_table(:, [end-2, end-1, end]) = [];
writetable(xy_table, '..\data_and_files\Build\��쳤�죨C+F�ߣ���Ҷ����.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\��쳤�죨C+F�ߣ���Ҷ��Ӧ����.xlsx', vars);
% ��˿�����ݣ�
[xy_table, vars] = getXY(["201507";"201706"], "��쳤��", 'C', 1);
writetable(xy_table, '..\data_and_files\Build\��쳤�죨C+F�ߣ���˿����.xlsx');
xy_table(:, [end-2, end-1, end]) = [];
writetable(xy_table, '..\data_and_files\Build\��쳤�죨C+F�ߣ���˿����.csv', ...
    'WriteVariableNames', false);
xlswrite('..\data_and_files\Build\��쳤�죨C+F�ߣ���˿��Ӧ����.xlsx', vars);

%% ������ش���Ŀǰ�������·ݣ�
% ��Ҷ+��˿�����ݣ�
% [xy_table, vars] = getXY(["201507";"201706"], "��쳤��", 'C', 2);