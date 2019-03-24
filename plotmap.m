function [b]=plotmap(getsum,xNum,figId)  %10个数据，图6
%PLOTMAP 此处显示有关此函数的摘要
%   此处显示详细说明
b = 0;
x=1:1:xNum;
y=getsum;
f=figure(figId); clf(f);
hold on;
plot(x,y);
hold off;
xlabel('K');
ylabel('WSS');
for i=1:length(x)-1
    z(i) = (y(i)-y(i+1))/(x(i)-x(i+1));
end
r=[];
for i=1:size(z,2)-1
    g(i)=z(i+1)-z(i);
    %if (g(i)>0.3&&y(i+1)>0 && y(i+1)<0.2)
    if (g(i)>0.03&&y(i+1)>0 && y(i+1)<0.08) %第x段和第x+1段之间仍然要有差距，且
        r=[r,g(i)];
    end
end
try
    a=r(1);
    b=find(a==g(1,:));
    b=b+1;
    %c = (z(2:end))-abs(z(1:end-1));
    %[a,b] = max(c)
catch
    fprintf(2,'ERROR$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n');
end

