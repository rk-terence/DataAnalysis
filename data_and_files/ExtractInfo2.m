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
