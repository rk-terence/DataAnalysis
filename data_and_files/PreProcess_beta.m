%% ��ձ����ռ䣬��ֹ��������ȡraw_stats
clear;
load raw_stats.mat;
%% �����Ա�����
variables = unique(raw_171.Varname);
save('17��1�����б�����Ӧ��','variables')%�õ������е����еı���������������ں�������
T = relationship(44655:46330,:);%17��1�µ��������ζ������
number_of_orders = length(unique(T.Workorder));%�����ܹ��м���������Ȼ���ʼ��xy_stats��

%% ��ʼ��table��xy_stats����ʼֵ��ΪNaN��
vector = zeros(number_of_orders,1);
for i = 1:number_of_orders
    vector(i) = NaN;
end
expression = "vector,";
for i = 2:length(variables)-1
    expression = expression + "vector,";
end
expression = expression + "vector";
eval("xy_stats = table(" + expression + ");");%��ʼ������

%% �������κŵ���Ϣ��ȡ����Ӧ��xy_stats��ȥ
row = 1;
for i = 1:height(T)
    productionorder = relationship.Workorder(i);
    %�������һ�����κŶ�Ӧ4������������Ѱ�ҡ�
    if T.Productionorder(i) == T.Productionorder(i+1) && T.Productionorder(i) == T.Productionorder(i+2) && T.Productionorder(i) == T.Productionorder(i+3)
        workorder = {relationship.Workorder(i)
            relationship.Workorder(i+1)
            relationship.Workorder(i+2)
            relationship.Workorder(i+3)};
        
        %��ȡ������Ӧ�����ݵ�smalltable�У����ڴ���.
        %��Ҫ��ȡ��ֵ����������
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
        
    
  