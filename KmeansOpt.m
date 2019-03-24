function [sum ] = KmeansOpt(PtCdir,sortId2,point,num)
%KMEANSOPT 此处显示有关此函数的摘要
%   此处显示详细说明
sum=0;
gettotaldis=[];
for i=1:num %不对
    totaldis=0.0;
    line=sortId2(sortId2==i,:);
    for j=1:size(line,1)
        line2=point(sortId2==i,:);
        distance=norm(line2(j,:)-PtCdir(i,:));
        distance2=distance^2;
        totaldis= totaldis+distance2;
    end
    avgdis=totaldis/size(line,1);
    gettotaldis=[gettotaldis,avgdis];
end
for i=1:size(gettotaldis,2)
    sum=sum+gettotaldis(1,i);
end

end

