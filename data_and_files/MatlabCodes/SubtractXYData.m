%% ��쳤����ش���Ŀǰ�������·ݣ�
% ��Ҷ+��˿�����ݣ�
[xy_table, vars] = getXY(["201507";"201706"], "��쳤��", 'C', 2);
writetable(xy_table, '..\data_and_files\��쳤�죨C+F�ߣ���Ҷ+��˿����.xlsx');
writetable(xy_table, '..\data_and_files\��쳤�죨C+F�ߣ���Ҷ+��˿����.csv');
xlswrite('..\data_and_files\��쳤�죨C+F�ߣ���Ҷ+��˿��Ӧ����.xlsx', vars);
% ��Ҷ�����ݣ�
[xy_table, vars] = getXY(["201507";"201706"], "��쳤��", 'C', 0);
writetable(xy_table, '..\data_and_files\��쳤�죨C+F�ߣ���Ҷ����.xlsx');
writetable(xy_table, '..\data_and_files\��쳤�죨C+F�ߣ���Ҷ����.csv');
xlswrite('..\data_and_files\��쳤�죨C+F�ߣ���Ҷ��Ӧ����.xlsx', vars);
% ��˿�����ݣ�
[xy_table, vars] = getXY(["201507";"201706"], "��쳤��", 'C', 1);
writetable(xy_table, '..\data_and_files\��쳤�죨C+F�ߣ���˿����.xlsx');
writetable(xy_table, '..\data_and_files\��쳤�죨C+F�ߣ���˿����.csv');
xlswrite('..\data_and_files\��쳤�죨C+F�ߣ���˿��Ӧ����.xlsx', vars);