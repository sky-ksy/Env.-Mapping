%根据求得的反射点数据绘制地图
clc; clear all;
param.srcPos=[0.5 0.5];
param=initParam(param);
global hasPlotted;
hasPlotted=[];

load('./data/trpMatrix4.mat');
n=length(trpMatrix);
for i=1:n
    plotRP(31,trpMatrix{i},param);
end

load('./data/rpMatrix4.mat');
n=length(rpMatrix);
for i=1:n
    plotRP(32,rpMatrix{i},param);
end

load('./data/erpMatrix4.mat');
n=length(erpMatrix);
for i=1:n
    mat=erpMatrix{i};
    plotId=(1:4:size(mat,1));
    eerpM{i}=mat(plotId,:);  %只绘制一部分反射点
    plotRP(33,erpMatrix{i},param);
    plotRP(34,eerpM{i},param);
end
load('./data/srcPos.mat');
figure(34);
% hold on;
% color1=[0.196 0.804 0.196];
% color2=[1 0 1];
% plot(srcPos(:,1),srcPos(:,2),'.','color',color2,'MarkerSize',12);

%求所有估计反射点与真实反射点的距离误差
ErrDis=cell(n,1);
for i=1:n
    trp=trpMatrix{i};  %robot在每个位置转一圈得到的反射点
    erp=eerpM{i};
    if ~isempty(erp)
        minDis=[];
        for j=1:size(erp,1)  %逐个求估计反射点与实际反射点的误差距离
            time=erp(j,3);
            ePos=erp(j,[1,2]);
            rightTime=find(trp(:,3)==time)';  %trp和erp相同时刻的反射点
            dis=[];
            rtId=[];
            for rt=rightTime
                tPos=trp(rt,[1,2]);
                rtId=[rtId,rt];
                e2t=tPos-ePos;
                dis=[dis,norm(e2t)];
            end
            [V,I]=min(dis);  %满足时刻要求的、与估计反射点距离最小的作为相应的真实反射点
            minDis(j)=V;
        end
        ErrDis{i}=minDis;  %一圈下来的反射点误差距离
    end   
end
% save('./data/ErrDis2.mat','ErrDis');

%合并求得的误差距离做统计
errdis=[];
for i=1:n
    errdis=[errdis,ErrDis{i}];    
end
sortErrDis=sort(errdis,'descend');
id=find(errdis<1e-3);
errdis(id)=[];
minAll=min(errdis);
maxAll=max(errdis);
meanAll=mean(errdis);
stdAll=std(errdis);
sta=[minAll,maxAll,meanAll,stdAll];