function [startrow, endrow] = FindWorkOrder(workorder, raw_production)
%% 本函数可以返回特定的workorder在某一个生产过程数据的table中第一次出现的行
%% 已经经过测试
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