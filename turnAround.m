function [endUserPos,theta,ref]=turnAround(srcPos,b_srcPos,b_userPos,param)
param.srcPos=srcPos;
param=initParam(param);  %设置src、初始化并绘制反射环境
apNum=length(param.virSrc);  %Tx在当前位置时所有可能的AP数

r=param.r;
delta=param.delta;
relativeAngle=param.relativeAngle;  %该角度为0时
count=0;
%生成真实坐标系下对应的Rx位置
for i=relativeAngle:delta:2*pi-delta
    count=count+1;
    userPos(count,:)=[srcPos(1)+r*cos(i),srcPos(2)+r*sin(i)];
end

%blind坐标系下Tx、Rx之间的初始AoA/AoD和不同的Rx位置
Tx2Rx=angle(complex(b_srcPos(1)-b_userPos(1,1),b_srcPos(2)-b_userPos(1,2)));
Rx2Tx=angle(complex(b_userPos(1,1)-b_srcPos(1),b_userPos(1,2)-b_srcPos(2)));

count=1;
for i=delta:delta:2*pi-delta
    count=count+1;
    b_userPos(count,:)=[b_srcPos(1)+r*cos(Rx2Tx+i),...
        b_srcPos(2)+r*sin(Rx2Tx+i)];
end

% f=figure(1); clf(f);
% hold on;
% plot(srcPos(1),srcPos(2),'k.','MarkerSize',15);
% plot(userPos(:,1),userPos(:,2),'.-','MarkerSize',15);
% hold off;
% legend('TX','RX');
% title('RX转动路线');

%考虑用户位置不同情况下锚点的估计情况
T=size(userPos,1);
fMatAoA=cell(T,1);
fMatRSS=cell(T,1);
fMatAnchor=cell(T,1);
errMatAoA=cell(T,1);
fovAoA=cell(T,1);
fovRSS=cell(T,1);
fovAnchor=cell(T,1);
MatAoA=cell(T,1);
MatRSS=cell(T,1);

for t=1:T  %转一圈
    fprintf(['第',num2str(t),'次采集\n']);
    toc
    [AoA,ARSS]=getAoARSS(userPos(t,:),param); %含有ARSS为0的AoA
    toc
    addZero=zeros(1,apNum-length(AoA));
    AoA=[AoA,addZero];
    ARSS=[ARSS,addZero];
    [value,TxId]=max(ARSS);   %最强的AoA来自Tx，用于后续的角度变换
    theta=Tx2Rx+delta*(t-1);  %记录Tx到Rx的到达角以供AoA转换
    if(theta>pi)
        theta=theta-2*pi;
    elseif(theta<=-pi)
        theta=theta+2*pi;
    end
    blindAoA=transferAoA(AoA,TxId,theta);  %blind坐标系下的AoA
    remainId=find(ARSS~=0);  %过滤ARSS为0的AoA
    anchorN=length(remainId);   %anchorN不同时刻可能变化
    anchorPos=zeros(anchorN,2);
    for ii=1:anchorN   %实际的各锚点位置
        id=remainId(ii);
        anchorPos(ii,:)=param.virSrc(id).pos;
    end
    %包含RSS为0的原始AoA
    %     MatAoA{t}=AoA;
    MatAoA{t}=blindAoA;
    MatRSS{t}=ARSS;
    
    %不含RSS为0的过滤AoA，没有考虑Tx Rx朝向
    fMatAnchor{t}=anchorPos;
    %     fMatAoA{t}=AoA(remainId);
    fMatAoA{t}=blindAoA(remainId);
    fMatRSS{t}=ARSS(remainId);
    
    
    %给AoA加误差*************************************
    aoa=blindAoA(remainId);
    rss=ARSS(remainId);
    aoa=genErrorAoA(aoa,rss);
%     errId=randperm(length(aoa),2);   %随机选两个方向的AoA
%     aoa(errId)=aoa(errId)+pi/180*2;  %误差两度
%     gtPi=find(aoa>pi);
%     aoa(gtPi)=aoa(gtPi)-2*pi;
%     leqNegPi=find(aoa<=-pi);
%     aoa(leqNegPi)=aoa(leqNegPi)+2*pi; %范围限制在（-pi,pi]
    errMatAoA{t}=aoa;
    %给AoA加误差*************************************
    
    %考虑Tx Rx朝向:只接收逆时针旋转朝向的AoA
    if(theta<0)
        Rx2Tx=pi+theta;
        tempAoA=fMatAoA{t};
        id1=intersect(find(Rx2Tx<tempAoA),find(tempAoA<=pi));
        id2=intersect(find(-pi<tempAoA),find(tempAoA<theta));
        id=union(id1,id2);  %跨-pi的那部分角度
        fovAoA{t}=tempAoA(id);
        fovRSS{t}=fMatRSS{t}(id);
        fovAnchor{t}=fMatAnchor{t}(id,:);
    else
        Rx2Tx=theta-pi;
        tempAoA=fMatAoA{t};
        id=intersect(find(Rx2Tx<tempAoA), find(tempAoA<theta)); %跨0的那部分角度
        fovAoA{t}=tempAoA(id);
        fovRSS{t}=fMatRSS{t}(id);
        fovAnchor{t}=fMatAnchor{t}(id,:);
    end
    toc
end
endUserPos=userPos(t,:);

aviApId=plotRealCluster(2,MatAoA,MatRSS,param);  %绘制真实AoA/RSS聚类情况fig2
clusters=getCluster(fMatAoA,fMatRSS,param.color);  %聚类并绘制聚类结果fig3、4
errClusters=getCluster(errMatAoA,fMatRSS,param.color);  %覆盖fig3、4

% save(['./groupMedianAP/errClusters',num2str(param.TxP),'.mat'],'errClusters');
% save(['./groupMedianAP/userPos',num2str(param.TxP),'.mat'],'userPos');

% [simuAoA,simuRSS]=getSimuAoARSS(fovAoA,fovRSS);  %根据转一圈的数据模仿实测AoA和RSS
% RealClusters=getCluster(simuAoA,simuRSS,param.color);  %对实测结果聚类

%根据聚类结果估计AP位置
% ap=getAp(clusters,userPos);
b_ap=getAp(clusters,b_userPos);  %blind坐标系下的ap位置
% load('./groupMedianAP/errClusters7.mat');
% load('./groupMedianAP/userPos7.mat');
errAp=getAp(errClusters,userPos);


%绘制真实坐标系下AP定位结果fig100
plotEstiResult(param,aviApId,errAp);  %有AoA误差的估计图
%求真实反射点
trueRefPoint=getTrueRefPoint(param,aviApId,userPos);
ref.trpMatrix=plotRefPoint(20,trueRefPoint,param);

%无AoA误差聚类求反射点
refPoint=getRefPoint(b_ap,b_userPos,clusters);  %cell类型
ref.rpMatrix=plotRefPoint(21,refPoint,param);

%有AoA误差聚类求反射点
errRefPoint=getRefPoint(errAp,b_userPos,errClusters);  %cell类型
ref.erpMatrix=plotRefPoint(22,errRefPoint,param);
end
% if(param.TxP==1)
%     figure(param.envFig);
%     plotReflector(param.env_param, param.sys_param);
% end
