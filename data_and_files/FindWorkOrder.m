function [startrow, endrow] = FindWorkOrder(workorder, raw_production)
%% ���������Է����ض���workorder��ĳһ�������������ݵ�table�е�һ�γ��ֵ���
%% �Ѿ���������
endrow = 0;
startrow = endrow;
for i = 1:1:height(raw_production)
    if raw_production.Workorder(i) == workorder
        startrow = i;
        endrow = i;
        while raw_production.Workorder(i+1) == workorder
            endrow = i+1;
            i = i + 1;
        end
        break;
    end
end