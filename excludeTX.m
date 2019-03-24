function [Tx,other]=excludeTX(sort1,sort2)
AoA=sort1(:,1);
flag=true;
for i=1:length(AoA)-2  %筛选Tx指标待修改
    ADoA1=AoA(i+1)-AoA(i);    
    ADoA2=AoA(i+2)-AoA(i+1);
    ADoA1=wrapAngle(ADoA1);
    ADoA2=wrapAngle(ADoA2);
    if(abs(ADoA2-ADoA1)>pi/180)
        flag=false;
        break;
    end
end
if(flag==true)
    other=sort2;
    Tx=sort1;
else
    other=sort1;
    Tx=sort2;
end
