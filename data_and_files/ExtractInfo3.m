filename = "CuttobaccoTest.xlsx";

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_longsi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_shortsi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_midsi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_completesi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "��˿��");
endrow = length(xls) + 2;
raw_brokensi = importfilefromexcel3(filename, "��˿��", 3, endrow);

xls = xlsread(filename, "���ֵ");
endrow = length(xls) + 2;
raw_fillsi = importfilefromexcel3(filename, "���ֵ", 3, endrow);


%����������
raw_fillsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_longsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_shortsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_midsi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};
raw_completesi.Properties.VariableNames = {'undefined', 'Number', 'Value', 'Time', 'Workorder', 'Productionorder', 'Category'};

