function [goodIntersection]=getGoodAp(points)
D = pdist(points,'euclidean');
AA = row2triu(D); %向量转对称矩阵：每个点到其它各点的距离
pN=size(points,1); %交点个数

pointGroup={};
maxLen=1;
maxStd=1e5;
maxGpId=0;
for i=1:pN
    id=find(AA(i,:)<0.3);  %找剧当前点距离小于x米的点,可调！！！
    pointGroup{i}=[length(id),id];
    if (length(id)>maxLen)
        maxLen=length(id);
        maxGpId=i; %记录中心点
        maxGp=id;  %记录距离近的一组点
        maxStd=std(AA(i,id),'omitnan');
    elseif (length(id)==maxLen)
        curStd=std(AA(i,id),'omitnan');
        if curStd<maxStd   %个数相同时比较距离的方差
            maxLen=length(id);
            maxGpId=i; %记录中心点
            maxGp=id;  %记录距离近的一组点
            maxStd=std(AA(i,id),'omitnan');
        end
    end
end
if maxGpId==0
   fprintf(2,'No AP Group\n');
   goodIntersection=median(points,1,'omitnan');
   return;
end
goodPoints=points([maxGpId,maxGp],:); %聚集数最多的一组点的坐标
goodIntersection=median(goodPoints,1,'omitnan');


% num=size(point,1); %交点个数
% [x,xid]=sort(point(:,1)); %以x坐标为准对点重新排列
% y=point(xid,2);
% for i=1:num
%
% end