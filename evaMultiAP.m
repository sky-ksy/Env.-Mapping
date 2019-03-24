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

srcPos=[7.8 0.2]; %设置一个AP在右下角
%与实际环境对应的Tx、Rx的blind初始化
b_srcPos=srcPos-[0 0];  %Tx起点设为原点，对应于实际的[3 6]

param.relativeAngle=0;  %Tx-Rx连线与真实坐标系x轴正向夹角
n=size(srcPos,1);
f=figure(param.envFig); clf(f);

r=(0.1:0.2:1);  %一个Rx以r为半径绕AP旋转
for i=length(r):length(r)
    param.TxP=i;
    param.r=r(i);
    param.delta=pi/(16*r(i)); %16越大，采样点越多
    b_userPos=b_srcPos+[param.r,0];  %Rx每次初始位置设为Tx+[r,0],为robot坐标系的x轴
    [endUserPos,theta]=turnBrokenAround(srcPos,b_srcPos,b_userPos,param);
end
