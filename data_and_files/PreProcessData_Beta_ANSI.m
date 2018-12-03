function [xy_stats, variables] = PreProcessData_Beta_UTF8(month, year, raw_data)
%���ű����԰���ĳһ���µ�ԭʼ���ݰ���x-y�Ĺ�ϵ����һ���µ�table���
%��Ȼ�󱣴浽һ��.csv����excel�ļ��У��Կ��Է���֮���Ϊ׼������
%
%����������������֣�һ��raw_data�����У��������λ���֣���17��raw_data��raw_171��
%����ʹ�ñ�����֮ǰclearһ�±����ռ䣬��ֹ���ţ��������벻���Ľ��
%
%1.2���£�ʹ��logical indexing����������ٶȡ��������߼���
%
%�汾��1.2
%
%Remaining problems: If a production order is matched with more than 4
%workorders, data extracted may not be precise. However, this case is rare,
%so it will not be solved at once.

%% ��ȡ��Ҫʹ�õ����ݣ����ļ��У�
load raw_stats.mat relationship raw_fillsi raw_longsi raw_midsi raw_shortsi raw_brokensi raw_completesi raw_bigleaf raw_bmleaf raw_midleaf raw_brokenleaf; 
%% �����Ա�����
variables = unique(raw_data.Varname);
%save(%�õ������е����еı���������������ں�������
%�õ� string monthyear��Ϊ֮��Ĳ�����׼����table T�Ĵ���
if month <= 9
    monthyear = "20" + string(year) + "0" + string(month);
else
    monthyear = "20" + string(year) + string(month);
end



po_array = relationship.Productionorder;
po_array = char(po_array);
po_array = po_array(:,1:6);
po_array = string(po_array);%��po_array���һ�������ꡢ�µ�string array

%����Ĵ������Ի�þ��󲿷������������ض�ʱ������κš�
startrow = find(po_array==monthyear, 1, 'first');
endrow = find(po_array==monthyear, 1, 'last');
T = relationship(startrow:endrow,:);
%ɾ��T�е��й�X��Y�����������������о���������
po_array = T.Productionorder;
po_array = char(po_array);
po_array = po_array(:,9);%��po_array���һ������һ����ĸ��char array
rows = [find(po_array=='X');
        find(po_array=='Y')];
T(rows,:) = [];%ɾ������

number_of_orders = length(unique(T.Productionorder));%�����ܹ��м���������Ȼ���ʼ��xy_stats��

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

%��������
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

%% �������κŵ���Ϣ��ȡ����Ӧ��xy_stats��ȥ
row = 1;
for i = 1:height(T)-3
    productionorder = T.Productionorder(i);
    %�������һ�����κŶ�Ӧ4������������Ѱ�ҡ�
    if T.Productionorder(i) == T.Productionorder(i+1) && T.Productionorder(i) == T.Productionorder(i+2) && T.Productionorder(i) == T.Productionorder(i+3)
        workorder = {categorical(T.Workorder(i))
            categorical(T.Workorder(i+1))
            categorical(T.Workorder(i+2))
            categorical(T.Workorder(i+3))};
        
        %��ȡ������Ӧ�����ݵ�smalltable�У����ڴ���.
        %��Ҫ��ȡ��ֵ����������
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
        
        %�����������л��ڣ�������С��������κ��С���
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
        
%% ��xy_stats�������Ĳ�����polishing
xy_stats = xy_stats(:, [length(variables)+1, length(variables)+2, 1:length(variables), length(variables)+3:length(variables)+12]);
