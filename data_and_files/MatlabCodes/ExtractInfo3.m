filename = "CuttobaccoTest.xlsx";

xls = xlsread(filename, "长丝率");
endrow = length(xls) + 2;
raw_longsi = importfilefromexcel3(filename, "长丝率", 3, endrow);

xls = xlsread(filename, "短丝率");
endrow = length(xls) + 2;
raw_shortsi = importfilefromexcel3(filename, "短丝率", 3, endrow);

xls = xlsread(filename, "中丝率");
endrow = length(xls) + 2;
raw_midsi = importfilefromexcel3(filename, "中丝率", 3, endrow);

xls = xlsread(filename, "整丝率");
endrow = length(xls) + 2;
raw_completesi = importfilefromexcel3(filename, "整丝率", 3, endrow);

xls = xlsread(filename, "碎丝率");
endrow = length(xls) + 2;
raw_brokensi = importfilefromexcel3(filename, "碎丝率", 3, endrow);

xls = xlsread(filename, "填充值");
endrow = length(xls) + 2;
raw_fillsi = importfilefromexcel3(filename, "填充值", 3, endrow);


%更改列名称
raw_fillsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_longsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_shortsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_completesi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_brokensi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

