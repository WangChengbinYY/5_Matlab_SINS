function Y = Leo_InsertData(X1,Y1,X2,Y2,X)
%仅考虑在两个时间中间 插入一个值，其它情况以后完善 x2 != x1
    Y = (X-X1)*(Y2-Y1)/(X2-X1) + Y1;
end