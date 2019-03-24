function clusters=getCluster0(MatAoA,MatRSS,color)
%用聚类区分Tx和其它虚拟锚点，可能不准
T=size(MatAoA,1);
allAoA=[];
allRSS=[];
RxId=[];
%不同时刻采集的AoA/RSS汇总到一起
for t=1:T
   AoAt=MatAoA{t}; 
   RSSt=MatRSS{t}; 
   allAoA=[allAoA,AoAt];
   allRSS=[allRSS,RSSt];
   tn=size(AoAt,2);
   RxId=[RxId,zeros(1,tn)+t];
end
originInfo=[allAoA',allRSS',RxId'];

%聚类
DIS='seuclidean';
method='median';  %median  centroid
%将TX对应的直线剔除出来
sortN=2;
X0=originInfo(:,1:2);
sortId=sortCluster(X0,DIS,method,sortN);  %分2类
info.origin=originInfo;
info.sortId=sortId;
info.DIS=DIS;
info.method=method;
plotSortedMap(3,info,sortN,color)  %绘制分类结果
sort1=originInfo(sortId==1,:);
sort2=originInfo(sortId==2,:);
[Tx,toSorted]=excludeTX(sort1,sort2);  %得到TX以外的虚拟AP 待修改？？？
clusters{1}=Tx;  %存储Tx分类

%进一步对剩余虚拟AP进行分类
sortN=5;
X1=toSorted(:,1:2);
nearPi=find(X1(:,1)<-2.8);
flipPi=X1;
flipPi(nearPi,1)=-flipPi(nearPi,1);  %对接近Pi的负角度取反
sortId=sortCluster(flipPi,DIS,method,sortN);  %分4类  待修改？？？
info.origin=X1;
info.sortId=sortId;
plotSortedMap(4,info,sortN,color)  %绘制分类结果

%存储进一步的分类结果
n=length(clusters);
for i=1:sortN  %每一团点对应一个AP，每个点对应不同时刻的RX位置    
    clusters{n+i}=toSorted(sortId==i,:);
end


