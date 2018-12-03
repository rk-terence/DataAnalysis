%load raw_stats_charlie.mat;
height = height(relationship);
vector=cell(height,1);  % vector存储将要合并的牌号信息。

for i=1542:height %从1542开始是除去生产变量表中没有而生产批次中有的批次。
    row = find(raw_data.Workorder == relationship.Workorder(i),1,'first');
    vector{i} = raw_data.Category(row);
end

relationship_charlie = [relationship, vector]; %扩充当前的relationship表
relationship_charlie.Properties.VariableNames{5} = 'Category';

% 删除无对应的工单号的条目
j = 1;
for i = 1:height
    if(isempty(relationship_charlie.Category{i}))
        rows(j) = i;
        j = j + 1;
    end
end
relationship_charlie(rows, :) = [];

%删除X，Y工序
height = height(relationship_charlie);
rows = [];
j = 1;
for i = 1:height
    pro_char = char(relationship_charlie.Productionorder(i));
    if(pro_char(9) == 'X' || pro_char(9) == 'Y')
        rows(j) = i;
        j = j + 1;
    end
end
relationship_charlie(rows, :) = [];