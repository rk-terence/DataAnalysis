%% 清空变量空间，防止出错，并读取raw_stats
clear;
load raw_stats.mat;
%% 常数性变量。
variables = unique(raw_171.Varname);
save('17年1月所有变量对应表','variables')%得到本月有的所有的变量。并输出，便于后续处理。
T = relationship(44655:46330,:);%17年1月的生产批次都在这里。
number_of_orders = length(unique(T.Workorder));%计算总共有几个工单，然后初始化xy_stats。

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

%% 将本批次号的信息提取到相应的xy_stats中去
row = 1;
for i = 1:height(T)
    productionorder = relationship.Workorder(i);
    %如果满足一个批次号对应4个工单，继续寻找。
    if T.Productionorder(i) == T.Productionorder(i+1) && T.Productionorder(i) == T.Productionorder(i+2) && T.Productionorder(i) == T.Productionorder(i+3)
        workorder = {relationship.Workorder(i)
            relationship.Workorder(i+1)
            relationship.Workorder(i+2)
            relationship.Workorder(i+3)};
        
        %提取出来相应的数据到smalltable中，便于处理.
        %主要提取均值，变量名。
        startrow = find(raw_171.Workorder == workorder{1}, 1, 'first');
        endrow = find(raw_171.Workorder == workorder{1}, 1, 'last');
        smalltable1 = raw_171(startrow:endrow, [2, 6, 10, 12]);
        startrow = find(raw_171.Workorder == workorder{1}, 1, 'first');
        endrow = find(raw_171.Workorder == workorder{1}, 1, 'last');
        smalltable2 = raw_171(startrow:endrow, [2, 6, 10, 12]);
        startrow = find(raw_171.Workorder == workorder{1}, 1, 'first');
        endrow = find(raw_171.Workorder == workorder{1}, 1, 'last');
        smalltable3 = raw_171(startrow:endrow, [2, 6, 10, 12]);
        startrow = find(raw_171.Workorder == workorder{1}, 1, 'first');
        endrow = find(raw_171.Workorder == workorder{1}, 1, 'last');
        smalltable4 = raw_171(startrow:endrow, [2, 6, 10, 12]);
        smalltable = [smalltable1;
                    smalltable2;
                    smalltable3;
                    smalltable4];
        if(isempty(smalltable))
            continue;
        end
        for j = 1:(endrow-startrow+1)
            k = find(variables==smalltable.Varname(j));
            xy_stats{row, k} = smalltable.Average(j);
        end
        xy_stats.Productionorder = relationship.Productionorder(i);
        row = row + 1;
    end
end
        
    
  