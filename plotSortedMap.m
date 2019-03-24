function plotSortedMap(figId,Tx,toSorted,color)
%绘制聚类结果

f=figure(figId); clf(f);
hold on
plot(Tx(:,1)*180/pi,Tx(:,2),'.','MarkerSize',15,'Color',color(1,:));
plot(toSorted(:,1)*180/pi,toSorted(:,2),'.','MarkerSize',15,'Color',color(2,:));
%*180/pi
hold off
xlim([-190 190]);
xlabel('AoA');
ylabel('RSS');
set(gca,'FontSize',12);
title('分两类');
% saveas(4,['./picture/',DIS,' ',method,' clustN=',num2str(clustN),'.jpg']);