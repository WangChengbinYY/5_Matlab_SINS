function Y = Leo_InsertData(X1,Y1,X2,Y2,X)
%������������ʱ���м� ����һ��ֵ����������Ժ����� x2 != x1
    Y = (X-X1)*(Y2-Y1)/(X2-X1) + Y1;
end