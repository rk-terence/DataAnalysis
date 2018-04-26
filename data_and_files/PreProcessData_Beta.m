function xy_stats = PreProcessData_Beta(month, year, raw_data)
%���ű����԰���ĳһ���µ�ԭʼ���ݰ���x-y�Ĺ�ϵ����һ���µ�table���
%��Ȼ�󱣴浽һ��.csv����excel�ļ��У��Կ��Է���֮���Ϊ׼������
%
%����������������֣�һ��raw_data�����У��������λ���֣���17��raw_data��raw_171��
%����ʹ�ñ�����֮ǰclearһ�±����ռ䣬��ֹ���ţ��������벻���Ľ��
%�汾��0.9 ��Ŀǰ�����ܵ������ֵ��

%% ��ȡ��Ҫʹ�õ����ݣ����ļ��У�
load raw_stats.mat relationship raw_fillsi raw_longsi raw_midsi raw_shortsi raw_brokensi raw_completesi raw_bigleaf raw_bmleaf raw_midleaf raw_brokenleaf; 
%% �����Ա�����
variables = unique(raw_data.Varname);

%�õ� string monthyear��Ϊ֮��Ĳ�����׼����table T�Ĵ���
if month <= 9
    monthyear = "20" + string(year) + "0" + string(month);
else
    monthyear = "20" + string(year) + string(month);
end

%save('17��1�����б�����Ӧ��','variables')%�õ������е����еı���������������ں�������

po_array = relationship.Productionorder;
po_array = char(po_array);
po_array = po_array(:,1:6);
po_array = string(po_array);%��time_array���һ�������ꡢ�µ�string array

%����Ĵ������Ի�þ��󲿷������������ض�ʱ������κš�
startrow = find(po_array==monthyear, 1, 'first');
endrow = find(po_array==monthyear, 1, 'last');
T = relationship(startrow:endrow,:);
%ɾ��T�е��й�X��Y�����������������о���������
po_array = T.Productionorder;
po_array = char(po_array);
po_array = po_array(:,9);%��time_array���һ�������ꡢ�µ�string array
rows = [find(po_array=='X');
        find(po_array=='Y')];
T(rows,:) = [];%ɾ������

number_of_orders = length(unique(T.Workorder));%�����ܹ��м���������Ȼ���ʼ��xy_stats��

%% ��ʼ��table��xy_stats����ʼֵ��ΪNaN��
vector = zeros(number_of_orders/4,1);
for i = 1:number_of_orders/4
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
            k = find(variables==smalltable.Varname(j));
            xy_stats{row, k} = smalltable.Average(j);
        end
        xy_stats.Productionorder(row) = productionorder;
        xy_stats.Time(row) = T.Time(i);
        rows = find(raw_fillsi.Productionorder == productionorder);
        value = mean(raw_fillsi.Value(rows));
        xy_stats.Fillsi(row) = value;
        rows = find(raw_longsi.Productionorder == productionorder);
        value = mean(raw_longsi.Value(rows));
        xy_stats.Longsi(row) = value;
        rows = find(raw_midsi.Productionorder == productionorder);
        value = mean(raw_midsi.Value(rows));
        xy_stats.Midsi(row) = value;
        rows = find(raw_shortsi.Productionorder == productionorder);
        value = mean(raw_shortsi.Value(rows));
        xy_stats.Shortsi(row) = value;
        rows = find(raw_brokensi.Productionorder == productionorder);
        value = mean(raw_brokensi.Value(rows));
        xy_stats.Brokensi(row) = value;
        rows = find(raw_completesi.Productionorder == productionorder);
        value = mean(raw_completesi.Value(rows));
        xy_stats.Completesi(row) = value;
        rows = find(raw_bigleaf.Productionorder == productionorder);
        value = mean(raw_bigleaf.Value(rows));
        xy_stats.Bigleaf(row) = value;
        rows = find(raw_bmleaf.Productionorder == productionorder);
        value = mean(raw_bmleaf.Value(rows));
        xy_stats.Bmleaf(row) = value;
        rows = find(raw_midleaf.Productionorder == productionorder);
        value = mean(raw_midleaf.Value(rows));
        xy_stats.Midleaf(row) = value;
        rows = find(raw_brokenleaf.Productionorder == productionorder);
        value = mean(raw_brokenleaf.Value(rows));
        xy_stats.Brokenleaf(row) = value;
        
        row = row + 1;
    end
end
        
%% ��xy_stats�������Ĳ�����polishing
xy_stats = xy_stats(:, [length(variables)+1, length(variables)+2, 1:length(variables), length(variables)+3:length(variables)+12]);

%% ����õ���table���ļ�

