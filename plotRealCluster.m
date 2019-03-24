function aviApId=plotRealCluster(figId,MatAoA,MatRSS,param)
%绘制AoA和RSS关系图
srcPos=param.srcPos;
color=param.color;
T=size(MatAoA,1);
n=length(MatAoA{1});  %不同时刻可能观测到的总锚点数相同；且锚点次序没有变化
f=figure(figId); clf(f);
hold on;
k=0;  %锚点个数
aviApId=[];
for i=1:n  %对同一个锚点。  不同反射段对应的锚点，可能是同一锚点
    for j=1:T    %同一锚点不同时刻
        xAoA(j)=MatAoA{j}(i);
        yRSS(j)=MatRSS{j}(i);
    end
    if(~isempty(find(yRSS)~=0))
        k=k+1;
        aviApId=[aviApId,i];
        if k>8
           if mod(k,8)==0
               k=8;
           else
               k=mod(k,8);
           end
        end
        h(k)=plot(xAoA*180/pi,yRSS,'.','MarkerSize',15,'Color',color(k,:)); %不可见的锚点RSS为0
    end
end
hold off;
xlim([-190 190]);
xlabel('AoA');
ylabel('RSS');
set(gca,'FontSize',12);
title(['Real clusters   Tx at [',num2str(srcPos(1)),',',num2str(srcPos(2)),']']);
for i=1:k
    str{i}=['AP',num2str(i)];
end
legend(h,str,'location','best');
% set(gca,'FontSize',15);
% saveas(2,['../picture/','TX at [',num2str(srcPos(1)),',',num2str(srcPos(2)),']','.jpg']);