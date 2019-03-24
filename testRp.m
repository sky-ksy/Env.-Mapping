%������õķ�������ݻ��Ƶ�ͼ
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
    eerpM{i}=mat(plotId,:);  %ֻ����һ���ַ����
    plotRP(33,erpMatrix{i},param);
    plotRP(34,eerpM{i},param);
end
load('./data/srcPos.mat');
figure(34);
% hold on;
% color1=[0.196 0.804 0.196];
% color2=[1 0 1];
% plot(srcPos(:,1),srcPos(:,2),'.','color',color2,'MarkerSize',12);

%�����й��Ʒ��������ʵ�����ľ������
ErrDis=cell(n,1);
for i=1:n
    trp=trpMatrix{i};  %robot��ÿ��λ��תһȦ�õ��ķ����
    erp=eerpM{i};
    if ~isempty(erp)
        minDis=[];
        for j=1:size(erp,1)  %�������Ʒ������ʵ�ʷ�����������
            time=erp(j,3);
            ePos=erp(j,[1,2]);
            rightTime=find(trp(:,3)==time)';  %trp��erp��ͬʱ�̵ķ����
            dis=[];
            rtId=[];
            for rt=rightTime
                tPos=trp(rt,[1,2]);
                rtId=[rtId,rt];
                e2t=tPos-ePos;
                dis=[dis,norm(e2t)];
            end
            [V,I]=min(dis);  %����ʱ��Ҫ��ġ�����Ʒ���������С����Ϊ��Ӧ����ʵ�����
            minDis(j)=V;
        end
        ErrDis{i}=minDis;  %һȦ�����ķ����������
    end   
end
% save('./data/ErrDis2.mat','ErrDis');

%�ϲ���õ���������ͳ��
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