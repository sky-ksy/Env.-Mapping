x1=randn(10,1);  
x2=randn(10,1)+10;  
x3=randn(10,1)+20;  
x=[x1;x2;x3];  
y=randn(30,1);  

clusterN=1;
T=clusterdata([x,y],clusterN);  

color = [[0 0 0];
    [1 0 1];
    [0 1 1];
    [1 0 0];
    [0 1 0];
    [0 0 1];
    [1 1 1];
    [1 1 0];];
f=figure(1); clf(f);
hold on  
for i=1:clusterN
    temp1=find(T==i);  
    plot(x(temp1),y(temp1),'kd','markersize',10,'markerfacecolor',color(mod(i,8),:));  
end
hold off;

% legend('cluster 1','cluster 2','cluster 3','location','best');