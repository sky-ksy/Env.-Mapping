clc; clear all;
warning off;

param.envFig=500;
% ptsymb = {'bs','r^','md','go','c+'};
param.color = [[0 0 0];
    [1 0 1];
    [0 1 1];
    [1 0 0];
    [0 1 0];
    [0 0 1];
    [1 1 1];
    [1 1 0];];

srcPos=[7.8 0.2]; %����һ��AP�����½�
%��ʵ�ʻ�����Ӧ��Tx��Rx��blind��ʼ��
b_srcPos=srcPos-[0 0];  %Tx�����Ϊԭ�㣬��Ӧ��ʵ�ʵ�[3 6]

param.relativeAngle=0;  %Tx-Rx��������ʵ����ϵx������н�
n=size(srcPos,1);
f=figure(param.envFig); clf(f);

r=(0.1:0.2:1);  %һ��Rx��rΪ�뾶��AP��ת
for i=length(r):length(r)
    param.TxP=i;
    param.r=r(i);
    param.delta=pi/(16*r(i)); %16Խ�󣬲�����Խ��
    b_userPos=b_srcPos+[param.r,0];  %Rxÿ�γ�ʼλ����ΪTx+[r,0],Ϊrobot����ϵ��x��
    [endUserPos,theta]=turnBrokenAround(srcPos,b_srcPos,b_userPos,param);
end
