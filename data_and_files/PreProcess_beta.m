%% 处理2017.1的数据
%初始化table变量存储变量。
xy_stats = table;
xy_stats.
variables 

%初始化变量
i = 44655;
while i <= 46330
    productionorder = relationship.Workorder(i);
    if relationship.Productionorder(i) == relationship.Productionorder(i+1) && relationship.Productionorder(i) == relationship.Productionorder(i+2) && relationship.Productionorder(i) == relationship.Productionorder(i+3)
        workorder = {relationship.Workorder(i)
            relationship.Workorder(i+1)
            relationship.Workorder(i+2)
            relationship.Workorder(i+3)};
        
        [startrow, endrow] = FindWorkOrder(workorder(1,:), raw_171);
        for j = startrow:1:endrow
            
        end
        
    else
        i = i + 1;
        while relationship.Workorder(i) == productionorder
            i = i + 1;
        end
    end
end
        
    
  