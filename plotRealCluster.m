function aviApId=plotRealCluster(figId,MatAoA,MatRSS,param)
%����AoA��RSS��ϵͼ
srcPos=param.srcPos;
color=param.color;
T=size(MatAoA,1);
n=length(MatAoA{1});  %��ͬʱ�̿��ܹ۲⵽����ê������ͬ����ê�����û�б仯
f=figure(figId); clf(f);
hold on;
k=0;  %ê�����
aviApId=[];
for i=1:n  %��ͬһ��ê�㡣  ��ͬ����ζ�Ӧ��ê�㣬������ͬһê��
    for j=1:T    %ͬһê�㲻ͬʱ��
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
        h(k)=plot(xAoA*180/pi,yRSS,'.','MarkerSize',15,'Color',color(k,:)); %���ɼ���ê��RSSΪ0
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