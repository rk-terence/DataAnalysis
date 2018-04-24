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
