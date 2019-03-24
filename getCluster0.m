function clusters=getCluster0(MatAoA,MatRSS,color)
%�þ�������Tx����������ê�㣬���ܲ�׼
T=size(MatAoA,1);
allAoA=[];
allRSS=[];
RxId=[];
%��ͬʱ�̲ɼ���AoA/RSS���ܵ�һ��
for t=1:T
   AoAt=MatAoA{t}; 
   RSSt=MatRSS{t}; 
   allAoA=[allAoA,AoAt];
   allRSS=[allRSS,RSSt];
   tn=size(AoAt,2);
   RxId=[RxId,zeros(1,tn)+t];
end
originInfo=[allAoA',allRSS',RxId'];

%����
DIS='seuclidean';
method='median';  %median  centroid
%��TX��Ӧ��ֱ���޳�����
sortN=2;
X0=originInfo(:,1:2);
sortId=sortCluster(X0,DIS,method,sortN);  %��2��
info.origin=originInfo;
info.sortId=sortId;
info.DIS=DIS;
info.method=method;
plotSortedMap(3,info,sortN,color)  %���Ʒ�����
sort1=originInfo(sortId==1,:);
sort2=originInfo(sortId==2,:);
[Tx,toSorted]=excludeTX(sort1,sort2);  %�õ�TX���������AP ���޸ģ�����
clusters{1}=Tx;  %�洢Tx����

%��һ����ʣ������AP���з���
sortN=5;
X1=toSorted(:,1:2);
nearPi=find(X1(:,1)<-2.8);
flipPi=X1;
flipPi(nearPi,1)=-flipPi(nearPi,1);  %�Խӽ�Pi�ĸ��Ƕ�ȡ��
sortId=sortCluster(flipPi,DIS,method,sortN);  %��4��  ���޸ģ�����
info.origin=X1;
info.sortId=sortId;
plotSortedMap(4,info,sortN,color)  %���Ʒ�����

%�洢��һ���ķ�����
n=length(clusters);
for i=1:sortN  %ÿһ�ŵ��Ӧһ��AP��ÿ�����Ӧ��ͬʱ�̵�RXλ��    
    clusters{n+i}=toSorted(sortId==i,:);
end


