% /*************************************************************************************
%
%    Program:       Millimeter Wave Raytracing Simulator
%    File Name:     main.m
%    Authors:       Teng Wei
%    Contact:       twei7@wisc.edu
%    Version:       1.2
%    Date:          July 03, 2015  1:52PM
%
%    Update:        add 3-D reflection and device orientation
%    Author:        Anfu Zhou
%    Date:          Feb 2017
%  *************************************************************************************

clc; clear all;
warning off;
pathSetup

%src的结构：位置，路径长，反射损失，深度，ID，父亲ID
src = struct('pos', [0 0], 'pathlen', 0, 'refloss', 0,...
    'depth', 0, 'ID', 0, 'parentID', -1);

%环境参数中的反射物结构：起点，终点，反射率，渗透
% location1, location2, reflectivity, penetration

% env_param.reflector_list = ...      %这里设置了两个反射面
%     [0.5-1i, 1.5-1i, 1, 0;
%      2+0i,   2-2i, 1, 0;
%      0+2i, -1+1i, 1.0, 0.0;
%      -2-3i, -2+0.5i, 1.0, 0.0;
%      1+2i, 2+1i, 1.0, 0.0;
%      -0.5-0.5i, -0.5+0.5i, 1.0, 0.0];

env_param.reflector_list = ...      %这里设置一个6*4四壁房间
    [-3-1.5i, -3+2.5i, 1, 0;
    -3+2.5i,   3+2.5i, 1, 0;
    3+2.5i, 3-1.5i, 1.0, 0.0;
    3-1.5i, -3-1.5i, 1.0, 0.0;
    ];
env_param.reflector_id = -1;        %反射面ID初始为-1
env_param.exclude_list = [];        %排除的列表

%设置系统参数
sys_param.xlow = -3; sys_param.xhigh = 3;       %x轴范围
sys_param.ylow = -1.5; sys_param.yhigh = 2.5;   %y轴范围
sys_param.gridsize = 0.1;                       %网格大小
sys_param.virSrcN = 0;                          %virsrc数量
sys_param.target.pos = [-2, 2];              %目标位置
sys_param.target.RF = 60e9:1e6:61e9;            %目标频率
sys_param = figHandlerAsssign(sys_param);

%计算镜像点位置
disptitle('Recursion tree for virtual source')
sys_param.rec_depth = 1;
sys_param.max_recDepth = 1;
[virSrc, virRF] = findVirtualSrc(env_param, sys_param, src, []);    %调用findVirtualSrc算出virSrc，virRF

%绘制原始点，镜像点，反射面
disptitle('Visualizing setup')
sys_param.plotSysSetup = true;
sys_param.plotVirRF_print = true;
sys_param.plotVirSrc_print = true;
virSrc = [src virSrc];  %现在的virSrc的前半部分是src
virRF = [struct('info',[], 'ref', [], 'ID', 0) virRF];
plotSysSetup(env_param, sys_param, virRF, virSrc);      %绘制环境设置

%绘制信号强度图
disptitle('Visualizing signal intensity');
sys_param.visualIntensity_parRun = false;   %平行运行标志
sys_param.visualIntensity_plot = true;      %绘制标志
sys_param.visualIntensity_savefig = false;  %保存图片标志
sys_param.visualIntensity_allin1 = true;   %绘制到一张图标志
%[plotdata, area_data] = visualIntensity(env_param, sys_param, virSrc, virRF);


disptitle('AoA analysis');
sys_param.AoAAnalysize_RSSthres = 1e-10;    %RSS阀值
sys_param.AoAAnalysize_plotAoA = 1;         %绘制到达角标志
sys_param.AoAAnalysize_plotEnv = 1;         %绘制环境标志
sys_param.recursiveBeamTrace_useArrow = 1;  %使用箭头标志
[AoA,virS,ARSS,AoD] = AoAAnalysize(env_param, sys_param, virSrc, virRF);  %信号强度大于某一阈值的AoA

%JADE
[X,y]=Jade(AoA,ARSS,virS);
n=size(X,2);
fprintf('final MSE:');
m=testMSE(X,AoA,1,y)
for i=1:n
    tAoA(i) = angle(complex(X(1,i)-y(1), ...%源点坐标-目标点坐标 转换为 到达角
X(2,i)-y(2)));
end
[adoa,Ri]=generateR(tAoA,3,n);
%测试代码1
% n=length(virSrc);
% fprintf('pR,mT\n');  %mR,mT:9个非零，3个小于1； pR,pT 2个0； mR,pT全零；pR,mT 9个非零，4个小于0；
% for i=1:n
%     for j=[1:i-1,i+1:n]
%         %theta=abs(AoA(j)-AoA(i));%myT
%         theta=AoA(j)-AoA(i);%paperT
%         beta=pi/2-theta;
%         %R=[cos(beta),sin(beta);-sin(beta),cos(beta)]; %paperR
%         R=[cos(beta),-sin(beta);sin(beta),cos(beta)];%myR
%         y=sys_param.target.pos;
%         xi=virSrc(i).pos;
%         xj=virSrc(j).pos;
%         vi=2*(y-xi)/(norm(y-xi))^2;
%         bi=2*sin(theta);
%         sub=vi*R*(xj-xi)'-bi;
%         %         xi=X(:,i);
%         %         xj=X(:,j);
%         %         vi=2*(y-xi)/(norm(y-xi))^2;
%         %         bi=2*sin(theta);
%         %         sub=vi'*R*(xj-xi)-bi;
%         fprintf('i=%d,j=%d,sub=%f\n',i,j,sub);
%     end
% end
%测试代码2
% n=length(virSrc);
% X=zeros(2,n);
% for i=1:n
%    X(:,i)=virSrc(i).pos';
% end
% testX(X,AoA,sys_param);
% X
% for i=1:n
%     Xii=transCol(X,i,n);
%     [thetai,Ri]=generateR(AoA,i,n);
%     Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2));
%     bi=2*sin(thetai);
%     y=sys_param.target.pos';
%     vi=2*(y-X(:,i))/(norm(y-X(:,i)))^2;
%     sub=vi'*Mi-bi
% end
return;
