function plotSortedMap0(figId,info,sortN,color)
%绘制聚类结果
idx=info.sortId;
origin=info.origin;
DIS=info.DIS;
method=info.method;
f=figure(figId); clf(f);
hold on
for i = 1:sortN
    clust = find(idx==i);
    plot(origin(clust,1)*180/pi,origin(clust,2),'.','MarkerSize',15,'Color',color(i,:));
end  %*180/pi
hold off
xlim([-190 190]);
xlabel('AoA');
ylabel('RSS');
set(gca,'FontSize',12);
title([DIS,' ',method,' sortN=',num2str(sortN)']);
% saveas(4,['./picture/',DIS,' ',method,' clustN=',num2str(clustN),'.jpg']);