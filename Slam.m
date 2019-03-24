clc; clear all;
warning off;

param.r=0.5;  %Tx与Rx距离
param.delta=pi/8;
% ptsymb = {'bs','r^','md','go','c+'};
param.color = [[0 0 0];
    [1 0 1];
    [0 1 1];
    [1 0 0];
    [0 1 0];
    [0 0 1];
    [1 1 1];
    [1 1 0];];

%实际环境中Tx坐标
% srcPos=[3,6;
%     1 2;
%     2 3;
%     3 4;
%     4 5;
%     5 6;
%     6 7;
%     7 8;
%     4 9;
%     1 8;
%     2 9;
%     2 2];  
srcPos=generateSrc();
% f=figure(20); hold on;
% p1=plot(srcPos(:,1),srcPos(:,2),'.-','MarkerSize',12);

%与实际环境对应的Tx、Rx的blind初始化
b_srcPos=srcPos-[0 0];  %Tx起点设为原点，对应于实际的[3 6]
b_userPos=b_srcPos+[param.r,0];  %Rx每次初始位置设为Tx+[r,0],为robot坐标系的x轴
param.relativeAngle=0;  %Tx-Rx连线与真实坐标系x轴正向夹角
global hasPlotted;  %是否绘制过反射环境图
hasPlotted=[];
n=size(srcPos,1);
for i=1:5
%     if i==10
%         pause;
%     end
tic
    fprintf([num2str(i),'\n']);
    param.TxP=i;
    [~,~,ref]=turnAround(srcPos(i,:),b_srcPos(i,:),b_userPos(i,:),param);
    trpMatrix{i}=ref.trpMatrix;
    rpMatrix{i}=ref.rpMatrix;
    erpMatrix{i}=ref.erpMatrix;
    toc
end
save('./data/trpMatrix4.mat','trpMatrix');
save('./data/rpMatrix4.mat','rpMatrix');
save('./data/erpMatrix4.mat','erpMatrix');