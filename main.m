clc; clear all;
warning off;

% param.srcPos=[0,0.5];  %Tx坐标
% param.srcPos=[2.5,2];  %Tx坐标
param.srcPos=[3,6];      %Tx坐标
param.r=0.3;             %Tx与Rx距离
param=initParam(param);  %设置src、初始化并绘制环境
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
%生成Tx距离为0.3的一些Rx坐标并画图
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
title('RX转动路线');

%考虑用户位置不同情况下锚点的估计情况
T=size(userPos,1);
fMatAoA=cell(T,1);
fMatRSS=cell(T,1);
fMatAnchor=cell(T,1);
MatAoA=cell(T,1);
MatRSS=cell(T,1);

for t=1:T
    fprintf(['第',num2str(t),'次采集\n']);
    [AoA,ARSS]=getAoARSS(userPos(t,:),param); %含有ARSS为0的AoA
    addZero=zeros(1,apNum-length(AoA));
    AoA=[AoA,addZero];
    ARSS=[ARSS,addZero];
    remainId=find(ARSS~=0);  %过滤ARSS为0的AoA
    anchorN=length(remainId);   %anchorN不同时刻可能变化
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

aviApId=plotRealCluster(2,MatAoA,MatRSS,param);  %绘制真实AoA/RSS聚类情况fig2
clusters=getCluster(fMatAoA,fMatRSS,param.color);  %聚类并绘制聚类结果fig3、4

%根据聚类结果估计AP位置
ap=getAp(clusters,userPos);

%绘制AP定位结果fig100
plotEstiResult(param,aviApId,ap);

%求出并绘制反射点
refPoint=getRefPoint(ap,userPos,clusters);  %cell类型
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
