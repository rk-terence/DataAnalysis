filename = "LeafTest.xlsx";

xls = xlsread(filename,"大片率");
endrow = length(xls) + 2;
raw_bigleaf = importfilefromexcel2(filename, "大片率", 3, endrow);

xls = xlsread(filename,"中片率");
endrow = length(xls) + 2;
raw_midleaf = importfilefromexcel2(filename, "中片率", 3, endrow);

xls = xlsread(filename,"大中片率");
endrow = length(xls) + 2;
raw_bmleaf = importfilefromexcel2(filename, "大中片率", 3, endrow);

xls = xlsread(filename,"碎片率");
endrow = length(xls) + 2;
raw_brokenleaf = importfilefromexcel2(filename, "碎片率", 3, endrow);

%更改列名称
raw_bigleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_bmleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_brokenleaf.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

