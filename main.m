clc; clear all;
warning off;

% param.srcPos=[0,0.5];  %Tx����
% param.srcPos=[2.5,2];  %Tx����
param.srcPos=[3,6];      %Tx����
param.r=0.3;             %Tx��Rx����
param=initParam(param);  %����src����ʼ�������ƻ���
apNum=length(param.virSrc);
% ptsymb = {'bs','r^','md','go','c+'};
param.color = [[0 0 0];
    [1 0 1];
    [0 1 1];
    [1 0 0];
    [0 1 0];
    [0 0 1];
    [1 1 1];
    [1 1 0];];

srcPos=param.srcPos;
r=param.r;
count=0;
%����Tx����Ϊ0.3��һЩRx���겢��ͼ
for i=0:pi/8:2*pi-pi/8
    count=count+1;
    userPos(count,1)=srcPos(1)+r*cos(i);
    userPos(count,2)=srcPos(2)+r*sin(i);
end

f=figure(1); clf(f);
hold on;
plot(srcPos(1),srcPos(2),'k.','MarkerSize',15);
plot(userPos(:,1),userPos(:,2),'.-','MarkerSize',15,'LineWidth',2);
hold off;
legend('TX','RX');
set(gca,'FontSize',12);
title('RXת��·��');

%�����û�λ�ò�ͬ�����ê��Ĺ������
T=size(userPos,1);
fMatAoA=cell(T,1);
fMatRSS=cell(T,1);
fMatAnchor=cell(T,1);
MatAoA=cell(T,1);
MatRSS=cell(T,1);

for t=1:T
    fprintf(['��',num2str(t),'�βɼ�\n']);
    [AoA,ARSS]=getAoARSS(userPos(t,:),param); %����ARSSΪ0��AoA
    addZero=zeros(1,apNum-length(AoA));
    AoA=[AoA,addZero];
    ARSS=[ARSS,addZero];
    remainId=find(ARSS~=0);  %����ARSSΪ0��AoA
    anchorN=length(remainId);   %anchorN��ͬʱ�̿��ܱ仯
    anchorPos=zeros(anchorN,2);
    for ii=1:anchorN
        id=remainId(ii);
        anchorPos(ii,:)=param.virSrc(id).pos;
    end
    fMatAnchor{t}=anchorPos;
    fMatAoA{t}=AoA(remainId);
    fMatRSS{t}=ARSS(remainId);
    MatAoA{t}=AoA;
    MatRSS{t}=ARSS;
end

aviApId=plotRealCluster(2,MatAoA,MatRSS,param);  %������ʵAoA/RSS�������fig2
clusters=getCluster(fMatAoA,fMatRSS,param.color);  %���ಢ���ƾ�����fig3��4

%���ݾ���������APλ��
ap=getAp(clusters,userPos);

%����AP��λ���fig100
plotEstiResult(param,aviApId,ap);

%��������Ʒ����
refPoint=getRefPoint(ap,userPos,clusters);  %cell����
k=0;
for i=1:length(refPoint)
    row=size(refPoint{i},1);
    for j=1:row
        k=k+1;
        rpMatrix(k,:)= refPoint{i}(j,:);
    end
end
figure(100);
hold on;
plot(rpMatrix(:,1),rpMatrix(:,2),'k.','MarkerSize',10);
set(gca,'FontSize',12);
hold off;
