[XY_stats_ruan, Varnames_ruan] = PreProcessData_Charlie(2, 17, "利群（软长嘴）叶丝");
[XY_stats_hong, Varnames_hong] = PreProcessData_Charlie(2, 17, "利群（软红长嘴）叶丝");

% 转化为Excel格式：
writetable(XY_stats_hong, "软红长嘴叶丝数据（17年2月）.xlsx", 'FileType', 'spreadsheet');
xlswrite('软红长嘴叶丝数据对应变量名.xlsx',Varnames_hong);
writetable(XY_stats_ruan, "软长嘴叶丝数据（17年2月）.xlsx", 'FileType', 'spreadsheet');
xlswrite('软长嘴叶丝数据对应变量名.xlsx',Varnames_ruan);
