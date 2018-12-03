function [xy_stats, variables] = PreProcessData_Beta_UTF8(month, year, raw_data)
%本脚本可以把中某一个月的原始数据按照x-y的关系生成一个新的table表格。
%（然后保存到一个.csv或者excel文件中（以可以方便之后的为准））。
%
%输入参数：两个数字，一个raw_data。其中，年份是两位数字，如17，raw_data如raw_171。
%建议使用本函数之前clear一下变量空间，防止干扰，产生意想不到的结果
%
%1.2更新：使用logical indexing，提高运行速度。更新了逻辑。
%
%版本：1.2
%
%Remaining problems: If a production order is matched with more than 4
%workorders, data extracted may not be precise. However, this case is rare,
%so it will not be solved at once.

%% 读取需要使用的数据（从文件中）
load raw_stats.mat relationship raw_fillsi raw_longsi raw_midsi raw_shortsi raw_brokensi raw_completesi raw_bigleaf raw_bmleaf raw_midleaf raw_brokenleaf; 
%% 常数性变量。
variables = unique(raw_data.Varname);
%save(%得到本月有的所有的变量。并输出，便于后续处理。
%得到 string monthyear，为之后的查找做准备（table T的处理）
if month <= 9
    monthyear = "20" + string(year) + "0" + string(month);
else
    monthyear = "20" + string(year) + string(month);
end



po_array = relationship.Productionorder;
po_array = char(po_array);
po_array = po_array(:,1:6);
po_array = string(po_array);%把po_array变成一个仅有年、月的string array

%下面的代码块可以获得绝大部分生产批次在特定时间的批次号。
startrow = find(po_array==monthyear, 1, 'first');
endrow = find(po_array==monthyear, 1, 'last');
T = relationship(startrow:endrow,:);
%删除T中的有关X、Y工序（这两个工序不做研究）的批次
po_array = T.Productionorder;
po_array = char(po_array);
po_array = po_array(:,9);%把po_array变成一个仅有一个字母的char array
rows = [find(po_array=='X');
        find(po_array=='Y')];
T(rows,:) = [];%删除操作

number_of_orders = length(unique(T.Productionorder));%计算总共有几个工单，然后初始化xy_stats。

%% 初始化table：xy_stats。初始值都为NaN。
vector = zeros(number_of_orders,1);
for i = 1:number_of_orders
    vector(i) = NaN;
end
expression = "vector,";
for i = 2:length(variables)-1
    expression = expression + "vector,";
end
expression = expression + "vector";
eval("xy_stats = table(" + expression + ");");%初始化变量

%其他的列
xy_stats.Productionorder = categorical(vector);
xy_stats.Time = string(vector);
xy_stats.Fillsi = vector;
xy_stats.Longsi = vector;
xy_stats.Midsi = vector;
xy_stats.Shortsi = vector;
xy_stats.Brokensi = vector;
xy_stats.Completesi = vector;
xy_stats.Bigleaf = vector;
xy_stats.Bmleaf = vector;
xy_stats.Midleaf = vector;
xy_stats.Brokenleaf = vector;

%% 将本批次号的信息提取到相应的xy_stats中去
row = 1;
for i = 1:height(T)-3
    productionorder = T.Productionorder(i);
    %如果满足一个批次号对应4个工单，继续寻找。
    if T.Productionorder(i) == T.Productionorder(i+1) && T.Productionorder(i) == T.Productionorder(i+2) && T.Productionorder(i) == T.Productionorder(i+3)
        workorder = {categorical(T.Workorder(i))
            categorical(T.Workorder(i+1))
            categorical(T.Workorder(i+2))
            categorical(T.Workorder(i+3))};
        
        %提取出来相应的数据到smalltable中，便于处理.
        %主要提取均值，变量名。
        startrow = find(raw_data.Workorder == workorder{1}, 1, 'first');
        endrow = find(raw_data.Workorder == workorder{1}, 1, 'last');
        smalltable1 = raw_data(startrow:endrow, [2, 6, 10, 12]);
        startrow = find(raw_data.Workorder == workorder{2}, 1, 'first');
        endrow = find(raw_data.Workorder == workorder{2}, 1, 'last');
        smalltable2 = raw_data(startrow:endrow, [2, 6, 10, 12]);
        startrow = find(raw_data.Workorder == workorder{3}, 1, 'first');
        endrow = find(raw_data.Workorder == workorder{3}, 1, 'last');
        smalltable3 = raw_data(startrow:endrow, [2, 6, 10, 12]);
        startrow = find(raw_data.Workorder == workorder{4}, 1, 'first');
        endrow = find(raw_data.Workorder == workorder{4}, 1, 'last');
        smalltable4 = raw_data(startrow:endrow, [2, 6, 10, 12]);
        smalltable = [smalltable1;
                    smalltable2;
                    smalltable3;
                    smalltable4];
        if(isempty(smalltable))
            continue;
        end
        for j = 1:height(smalltable)
            xy_stats{row, variables==smalltable.Varname(j)} = smalltable.Average(j);
        end
        
        %增加其他的列环节（检测结果列、生产批次号列、）
        xy_stats.Productionorder(row) = productionorder;
        xy_stats.Time(row) = T.Time(i);
        xy_stats.Fillsi(row) = mean(raw_fillsi.Value(raw_fillsi.Productionorder == productionorder));
        xy_stats.Longsi(row) = mean(raw_longsi.Value(raw_longsi.Productionorder == productionorder));
        xy_stats.Midsi(row) = mean(raw_midsi.Value(raw_midsi.Productionorder == productionorder));
        xy_stats.Shortsi(row) = mean(raw_shortsi.Value(raw_shortsi.Productionorder == productionorder));
        xy_stats.Brokensi(row) = mean(raw_brokensi.Value(raw_brokensi.Productionorder == productionorder));
        xy_stats.Completesi(row) = mean(raw_completesi.Value(raw_completesi.Productionorder == productionorder));
        xy_stats.Bigleaf(row) = mean(raw_bigleaf.Value(raw_bigleaf.Productionorder == productionorder));
        xy_stats.Bmleaf(row) = mean(raw_bmleaf.Value(raw_bmleaf.Productionorder == productionorder));
        xy_stats.Midleaf(row) = mean(raw_midleaf.Value(raw_midleaf.Productionorder == productionorder));
        xy_stats.Brokenleaf(row) = mean(raw_brokenleaf.Value(raw_brokenleaf.Productionorder == productionorder));
        
        row = row + 1;
        i = i + 3;
    end
end
        
%% 对xy_stats进行最后的操作，polishing
xy_stats = xy_stats(:, [length(variables)+1, length(variables)+2, 1:length(variables), length(variables)+3:length(variables)+12]);
