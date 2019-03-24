function clusters=getCluster(MatAoA,MatRSS,color)
%人为区分出Tx和其它虚拟锚点
T=size(MatAoA,1);
Tx=[];
toSortedAoA=[];
toSortedRSS=[];
RxId=[];
%不同时刻采集的AoA/RSS汇总到一起
for t=1:T
    AoAt=MatAoA{t};
    RSSt=MatRSS{t};
    if ~isempty(AoAt)
        Tx=[Tx;AoAt(1),RSSt(1),t];
        toSortedAoA=[toSortedAoA,AoAt(2:end)];
        toSortedRSS=[toSortedRSS,RSSt(2:end)];
        tn=size(AoAt,2)-1;
        RxId=[RxId,zeros(1,tn)+t];
    end
end
toSorted=[toSortedAoA',toSortedRSS',RxId'];
plotSortedMap(3,Tx,toSorted,color)  %绘制分类结果
% originInfo=[allAoA',allRSS',RxId'];
%
%聚类
DIS='seuclidean';
method='median';  %median  centroid
% %将TX对应的直线剔除出来
% sortN=2;
% X0=originInfo(:,1:2);
% sortId=sortCluster(X0,DIS,method,sortN);  %分2类
% info.origin=originInfo;
% info.sortId=sortId;
info.DIS=DIS;
info.method=method;
% plotSortedMap(3,info,sortN,color)  %绘制分类结果
% sort1=originInfo(sortId==1,:);
% sort2=originInfo(sortId==2,:);
% [Tx,toSorted]=excludeTX(sort1,sort2);  %得到TX以外的虚拟AP 待修改？？？

clusters{1}=Tx;  %存储Tx分类
if (size(toSorted,1)==0)
    return;
end
%进一步对剩余虚拟AP进行分类
sortN=5;
X1=toSorted(:,1:2);
nearPi=find(X1(:,1)<-2.8);
flipPi=X1;
flipPi(nearPi,1)=-flipPi(nearPi,1);  %对接近Pi的负角度取反

% %MATLAB自带聚类
% sortId=sortCluster(flipPi,DIS,method,sortN);  %分4类  待修改？？？
% info.origin=X1;
% info.sortId=sortId;
% plotSortedMap0(4,info,sortN,color)  %绘制分类结果

% %存储进一步的分类结果
% n=length(clusters);
% for i=1:sortN  %每一团点对应一个AP，每个点对应不同时刻的RX位置
%     clusters{n+i}=toSorted(sortId==i,:);
% end

%Kmeans聚类
sortIDtotal={ };
getsum=[];
%norm=zscore(flipPi);
norm=mapminmax(flipPi(:,1)');   %X1里的数据是两边不一样的，flip里的两边是一样的
norm2=mapminmax(flipPi(:,2)',0,1);  %scale RSS to [0,1]
normT=[norm',norm2'];  %待聚类点的个数
% disp(length(normT));

nn=min(8,size(normT)); %聚类数不超过8
for i=1:nn
    [sortId2, PtCdir, Cpos]=Kmeans(normT,i);
    [sum]=KmeansOpt(PtCdir,sortId2,normT,i);
    sortIDtotal{i}=sortId2;
    getsum=[getsum,sum];
end
k=plotmap(getsum,nn,6);
if k==0
    return;
end
info.origin=X1;
info.sortId=sortIDtotal{k};
plotSortedMap0(4,info,k,color);  %绘制分类结果

%存储剩余分类
n=length(clusters);
for i=1:k  %每一团点对应一个AP，每个点对应不同时刻的RX位置
    %clusters{n+i}=toSorted(sortId==i,:);%行检索是sortID=i的时候，把属于这个条件的列都拿出来，存到某个cluster里
    clusters{n+i}=toSorted(sortIDtotal{k}==i,:);
end


