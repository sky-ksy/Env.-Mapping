clc; clear all;
warning off;

param.r=0.5;  %Tx��Rx����
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

%ʵ�ʻ�����Tx����
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

%��ʵ�ʻ�����Ӧ��Tx��Rx��blind��ʼ��
b_srcPos=srcPos-[0 0];  %Tx�����Ϊԭ�㣬��Ӧ��ʵ�ʵ�[3 6]
b_userPos=b_srcPos+[param.r,0];  %Rxÿ�γ�ʼλ����ΪTx+[r,0],Ϊrobot����ϵ��x��
param.relativeAngle=0;  %Tx-Rx��������ʵ����ϵx������н�
global hasPlotted;  %�Ƿ���ƹ����价��ͼ
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