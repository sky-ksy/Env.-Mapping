function [b]=plotmap(getsum,xNum,figId)  %10�����ݣ�ͼ6
%PLOTMAP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
    if (g(i)>0.03&&y(i+1)>0 && y(i+1)<0.08) %��x�κ͵�x+1��֮����ȻҪ�в�࣬��
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

