%load raw_stats_charlie.mat;
height = height(relationship);
vector=cell(height,1);  % vector�洢��Ҫ�ϲ����ƺ���Ϣ��

for i=1542:height %��1542��ʼ�ǳ�ȥ������������û�ж������������е����Ρ�
    row = find(raw_data.Workorder == relationship.Workorder(i),1,'first');
    vector{i} = raw_data.Category(row);
end

relationship_charlie = [relationship, vector]; %���䵱ǰ��relationship��
relationship_charlie.Properties.VariableNames{5} = 'Category';

% ɾ���޶�Ӧ�Ĺ����ŵ���Ŀ
j = 1;
for i = 1:height
    if(isempty(relationship_charlie.Category{i}))
        rows(j) = i;
        j = j + 1;
    end
end
relationship_charlie(rows, :) = [];

%ɾ��X��Y����
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