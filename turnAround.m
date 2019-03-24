function [endUserPos,theta,ref]=turnAround(srcPos,b_srcPos,b_userPos,param)
param.srcPos=srcPos;
param=initParam(param);  %����src����ʼ�������Ʒ��价��
apNum=length(param.virSrc);  %Tx�ڵ�ǰλ��ʱ���п��ܵ�AP��

r=param.r;
delta=param.delta;
relativeAngle=param.relativeAngle;  %�ýǶ�Ϊ0ʱ
count=0;
%������ʵ����ϵ�¶�Ӧ��Rxλ��
for i=relativeAngle:delta:2*pi-delta
    count=count+1;
    userPos(count,:)=[srcPos(1)+r*cos(i),srcPos(2)+r*sin(i)];
end

%blind����ϵ��Tx��Rx֮��ĳ�ʼAoA/AoD�Ͳ�ͬ��Rxλ��
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
% title('RXת��·��');

%�����û�λ�ò�ͬ�����ê��Ĺ������
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

for t=1:T  %תһȦ
    fprintf(['��',num2str(t),'�βɼ�\n']);
    toc
    [AoA,ARSS]=getAoARSS(userPos(t,:),param); %����ARSSΪ0��AoA
    toc
    addZero=zeros(1,apNum-length(AoA));
    AoA=[AoA,addZero];
    ARSS=[ARSS,addZero];
    [value,TxId]=max(ARSS);   %��ǿ��AoA����Tx�����ں����ĽǶȱ任
    theta=Tx2Rx+delta*(t-1);  %��¼Tx��Rx�ĵ�����Թ�AoAת��
    if(theta>pi)
        theta=theta-2*pi;
    elseif(theta<=-pi)
        theta=theta+2*pi;
    end
    blindAoA=transferAoA(AoA,TxId,theta);  %blind����ϵ�µ�AoA
    remainId=find(ARSS~=0);  %����ARSSΪ0��AoA
    anchorN=length(remainId);   %anchorN��ͬʱ�̿��ܱ仯
    anchorPos=zeros(anchorN,2);
    for ii=1:anchorN   %ʵ�ʵĸ�ê��λ��
        id=remainId(ii);
        anchorPos(ii,:)=param.virSrc(id).pos;
    end
    %����RSSΪ0��ԭʼAoA
    %     MatAoA{t}=AoA;
    MatAoA{t}=blindAoA;
    MatRSS{t}=ARSS;
    
    %����RSSΪ0�Ĺ���AoA��û�п���Tx Rx����
    fMatAnchor{t}=anchorPos;
    %     fMatAoA{t}=AoA(remainId);
    fMatAoA{t}=blindAoA(remainId);
    fMatRSS{t}=ARSS(remainId);
    
    
    %��AoA�����*************************************
    aoa=blindAoA(remainId);
    rss=ARSS(remainId);
    aoa=genErrorAoA(aoa,rss);
%     errId=randperm(length(aoa),2);   %���ѡ���������AoA
%     aoa(errId)=aoa(errId)+pi/180*2;  %�������
%     gtPi=find(aoa>pi);
%     aoa(gtPi)=aoa(gtPi)-2*pi;
%     leqNegPi=find(aoa<=-pi);
%     aoa(leqNegPi)=aoa(leqNegPi)+2*pi; %��Χ�����ڣ�-pi,pi]
    errMatAoA{t}=aoa;
    %��AoA�����*************************************
    
    %����Tx Rx����:ֻ������ʱ����ת�����AoA
    if(theta<0)
        Rx2Tx=pi+theta;
        tempAoA=fMatAoA{t};
        id1=intersect(find(Rx2Tx<tempAoA),find(tempAoA<=pi));
        id2=intersect(find(-pi<tempAoA),find(tempAoA<theta));
        id=union(id1,id2);  %��-pi���ǲ��ֽǶ�
        fovAoA{t}=tempAoA(id);
        fovRSS{t}=fMatRSS{t}(id);
        fovAnchor{t}=fMatAnchor{t}(id,:);
    else
        Rx2Tx=theta-pi;
        tempAoA=fMatAoA{t};
        id=intersect(find(Rx2Tx<tempAoA), find(tempAoA<theta)); %��0���ǲ��ֽǶ�
        fovAoA{t}=tempAoA(id);
        fovRSS{t}=fMatRSS{t}(id);
        fovAnchor{t}=fMatAnchor{t}(id,:);
    end
    toc
end
endUserPos=userPos(t,:);

aviApId=plotRealCluster(2,MatAoA,MatRSS,param);  %������ʵAoA/RSS�������fig2
clusters=getCluster(fMatAoA,fMatRSS,param.color);  %���ಢ���ƾ�����fig3��4
errClusters=getCluster(errMatAoA,fMatRSS,param.color);  %����fig3��4

% save(['./groupMedianAP/errClusters',num2str(param.TxP),'.mat'],'errClusters');
% save(['./groupMedianAP/userPos',num2str(param.TxP),'.mat'],'userPos');

% [simuAoA,simuRSS]=getSimuAoARSS(fovAoA,fovRSS);  %����תһȦ������ģ��ʵ��AoA��RSS
% RealClusters=getCluster(simuAoA,simuRSS,param.color);  %��ʵ��������

%���ݾ���������APλ��
% ap=getAp(clusters,userPos);
b_ap=getAp(clusters,b_userPos);  %blind����ϵ�µ�apλ��
% load('./groupMedianAP/errClusters7.mat');
% load('./groupMedianAP/userPos7.mat');
errAp=getAp(errClusters,userPos);


%������ʵ����ϵ��AP��λ���fig100
plotEstiResult(param,aviApId,errAp);  %��AoA���Ĺ���ͼ
%����ʵ�����
trueRefPoint=getTrueRefPoint(param,aviApId,userPos);
ref.trpMatrix=plotRefPoint(20,trueRefPoint,param);

%��AoA�����������
refPoint=getRefPoint(b_ap,b_userPos,clusters);  %cell����
ref.rpMatrix=plotRefPoint(21,refPoint,param);

%��AoA�����������
errRefPoint=getRefPoint(errAp,b_userPos,errClusters);  %cell����
ref.erpMatrix=plotRefPoint(22,errRefPoint,param);
end
% if(param.TxP==1)
%     figure(param.envFig);
%     plotReflector(param.env_param, param.sys_param);
% end
