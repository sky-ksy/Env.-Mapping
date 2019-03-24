function [goodIntersection]=getGoodAp(points)
D = pdist(points,'euclidean');
AA = row2triu(D); %����ת�Գƾ���ÿ���㵽��������ľ���
pN=size(points,1); %�������

pointGroup={};
maxLen=1;
maxStd=1e5;
maxGpId=0;
for i=1:pN
    id=find(AA(i,:)<0.3);  %�Ҿ統ǰ�����С��x�׵ĵ�,�ɵ�������
    pointGroup{i}=[length(id),id];
    if (length(id)>maxLen)
        maxLen=length(id);
        maxGpId=i; %��¼���ĵ�
        maxGp=id;  %��¼�������һ���
        maxStd=std(AA(i,id),'omitnan');
    elseif (length(id)==maxLen)
        curStd=std(AA(i,id),'omitnan');
        if curStd<maxStd   %������ͬʱ�ȽϾ���ķ���
            maxLen=length(id);
            maxGpId=i; %��¼���ĵ�
            maxGp=id;  %��¼�������һ���
            maxStd=std(AA(i,id),'omitnan');
        end
    end
end
if maxGpId==0
   fprintf(2,'No AP Group\n');
   goodIntersection=median(points,1,'omitnan');
   return;
end
goodPoints=points([maxGpId,maxGp],:); %�ۼ�������һ��������
goodIntersection=median(goodPoints,1,'omitnan');


% num=size(point,1); %�������
% [x,xid]=sort(point(:,1)); %��x����Ϊ׼�Ե���������
% y=point(xid,2);
% for i=1:num
%
% end