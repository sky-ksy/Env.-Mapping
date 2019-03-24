function clusters=getCluster(MatAoA,MatRSS,color)
%��Ϊ���ֳ�Tx����������ê��
T=size(MatAoA,1);
Tx=[];
toSortedAoA=[];
toSortedRSS=[];
RxId=[];
%��ͬʱ�̲ɼ���AoA/RSS���ܵ�һ��
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
plotSortedMap(3,Tx,toSorted,color)  %���Ʒ�����
% originInfo=[allAoA',allRSS',RxId'];
%
%����
DIS='seuclidean';
method='median';  %median  centroid
% %��TX��Ӧ��ֱ���޳�����
% sortN=2;
% X0=originInfo(:,1:2);
% sortId=sortCluster(X0,DIS,method,sortN);  %��2��
% info.origin=originInfo;
% info.sortId=sortId;
info.DIS=DIS;
info.method=method;
% plotSortedMap(3,info,sortN,color)  %���Ʒ�����
% sort1=originInfo(sortId==1,:);
% sort2=originInfo(sortId==2,:);
% [Tx,toSorted]=excludeTX(sort1,sort2);  %�õ�TX���������AP ���޸ģ�����

clusters{1}=Tx;  %�洢Tx����
if (size(toSorted,1)==0)
    return;
end
%��һ����ʣ������AP���з���
sortN=5;
X1=toSorted(:,1:2);
nearPi=find(X1(:,1)<-2.8);
flipPi=X1;
flipPi(nearPi,1)=-flipPi(nearPi,1);  %�Խӽ�Pi�ĸ��Ƕ�ȡ��

% %MATLAB�Դ�����
% sortId=sortCluster(flipPi,DIS,method,sortN);  %��4��  ���޸ģ�����
% info.origin=X1;
% info.sortId=sortId;
% plotSortedMap0(4,info,sortN,color)  %���Ʒ�����

% %�洢��һ���ķ�����
% n=length(clusters);
% for i=1:sortN  %ÿһ�ŵ��Ӧһ��AP��ÿ�����Ӧ��ͬʱ�̵�RXλ��
%     clusters{n+i}=toSorted(sortId==i,:);
% end

%Kmeans����
sortIDtotal={ };
getsum=[];
%norm=zscore(flipPi);
norm=mapminmax(flipPi(:,1)');   %X1������������߲�һ���ģ�flip���������һ����
norm2=mapminmax(flipPi(:,2)',0,1);  %scale RSS to [0,1]
normT=[norm',norm2'];  %�������ĸ���
% disp(length(normT));

nn=min(8,size(normT)); %������������8
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
plotSortedMap0(4,info,k,color);  %���Ʒ�����

%�洢ʣ�����
n=length(clusters);
for i=1:k  %ÿһ�ŵ��Ӧһ��AP��ÿ�����Ӧ��ͬʱ�̵�RXλ��
    %clusters{n+i}=toSorted(sortId==i,:);%�м�����sortID=i��ʱ�򣬰���������������ж��ó������浽ĳ��cluster��
    clusters{n+i}=toSorted(sortIDtotal{k}==i,:);
end


