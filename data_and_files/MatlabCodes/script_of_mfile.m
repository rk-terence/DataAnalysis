[XY_stats_ruan, Varnames_ruan] = PreProcessData_Charlie(2, 17, "��Ⱥ�����죩Ҷ˿");
[XY_stats_hong, Varnames_hong] = PreProcessData_Charlie(2, 17, "��Ⱥ����쳤�죩Ҷ˿");

% ת��ΪExcel��ʽ��
writetable(XY_stats_hong, "��쳤��Ҷ˿���ݣ�17��2�£�.xlsx", 'FileType', 'spreadsheet');
xlswrite('��쳤��Ҷ˿���ݶ�Ӧ������.xlsx',Varnames_hong);
writetable(XY_stats_ruan, "����Ҷ˿���ݣ�17��2�£�.xlsx", 'FileType', 'spreadsheet');
xlswrite('����Ҷ˿���ݶ�Ӧ������.xlsx',Varnames_ruan);
