filename = "LeafTest.xlsx";

xls = xlsread(filename,"��Ƭ��");
endrow = length(xls) + 2;
raw_bigleaf = importfilefromexcel2(filename, "��Ƭ��", 3, endrow);

xls = xlsread(filename,"��Ƭ��");
endrow = length(xls) + 2;
raw_midleaf = importfilefromexcel2(filename, "��Ƭ��", 3, endrow);

xls = xlsread(filename,"����Ƭ��");
endrow = length(xls) + 2;
raw_bmleaf = importfilefromexcel2(filename, "����Ƭ��", 3, endrow);

xls = xlsread(filename,"��Ƭ��");
endrow = length(xls) + 2;
raw_brokenleaf = importfilefromexcel2(filename, "��Ƭ��", 3, endrow);

%����������
raw_bigleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_bmleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_brokenleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

