function [param]=initParam(param)
srcPos=param.srcPos;
%环境参数中的反射物结构：起点，终点，反射率，渗透
% location1, location2, reflectivity, penetration

% env_param.reflector_list = ...      %这里设置了6个反射面
%     [0.5-1i, 1.5-1i, 1, 0;
%      2+0i,   2-2i, 1, 0;
%      0+2i, -1+1i, 1.0, 0.0;
%      -2-3i, -2+0.5i, 1.0, 0.0;
%      1+2i, 2+1i, 1.0, 0.0;
%      -0.5-0.5i, -0.5+0.5i, 1.0, 0.0];

% env_param.reflector_list = ...      %这里设置一个6*4矩形房间
%     [-3-1.5i, -3+2.5i, 1, 0;
%      -3+2.5i,   3+2.5i, 1, 0;
%      3+2.5i, 3-1.5i, 1.0, 0.0;
%      3-1.5i, -3-1.5i, 1.0, 0.0;
%      ];
% sys_param.xlow = -3; sys_param.xhigh = 3;       %x轴范围
% sys_param.ylow = -1.5; sys_param.yhigh = 2.5;       %y轴范围

% env_param.reflector_list = ...      %这里设置一个不规则四壁房间
%     [-4-2i, -3+3i, 1, 0;
%     -3+3i,   3+2.5i, 1, 0;
%     3+2.5i, 4-1.5i, 1.0, 0.0;
%     4-1.5i, -4-2i, 1.0, 0.0;
%     ];
% sys_param.xlow = -4; sys_param.xhigh = 4;       %x轴范围
% sys_param.ylow = -2; sys_param.yhigh = 3;       %y轴范围

env_param.reflector_list = ...      % Reflector list
    [-0.01-0.01i, 8.01- 0.01i, 0.5, 0;  %外圈墙1
     8.01+10.01i, 8.01- 0.01i, 0.5, 0;  %外圈墙2
     8.01+10.01i, 0.51+10.01i, 0.5, 0;  %外圈墙3
     0.51+ 6.41i, 0.51+10.01i, 0.5, 0;  %外圈墙4
     -0.01+6.41i, 2.51+ 6.41i, 0.8, 0;  %外圈锡纸墙5
     -0.01+6.41i, -0.01-0.01i, 0.3, 0;  %外圈板墙6
     
     2.95+10.01i, 2.95+7.61i, 0.8, 0;  %内部锡纸墙1
     4.95+ 7.61i, 2.95+7.61i, 0.7, 0;  %内部屏幕墙2
     6.01+ 7.61i, 8.01+7.61i, 0.6, 0;  %内部白板墙3
     
%      3.87+2.85i, 5.31+2.85i, 0.2, 0.8;  %桌子
%      5.31+5.15i, 5.31+2.85i, 0.2, 0.8;
%      5.31+5.15i, 3.87+5.15i, 0.2, 0.8;
%      3.87+2.85i, 3.87+5.15i, 0.2, 0.8;       
    ];
sys_param.xlow = -0.01; sys_param.xhigh = 8.01;  %绘图房间坐标范围
sys_param.ylow = -0.01; sys_param.yhigh = 10.01;


env_param.reflector_id = -1;        %反射面ID初始为-1
env_param.exclude_list = [];        %排除的列表
%设置RayTracer系统参数
sys_param.gridsize = 0.1;                       %RayTracer网格大小
sys_param.virSrcN = 0;                          %virSrc数量
sys_param.target.RF = 60e9:1e6:61e9;            %目标频率
sys_param = figHandlerAsssign(sys_param);

sys_param.rec_depth = 1;
sys_param.max_recDepth = 1;

sys_param.plotSysSetup = true;
sys_param.plotVirRF_print = true;
sys_param.plotVirSrc_print = true;

sys_param.visualIntensity_parRun = false;   %平行运行标志
sys_param.visualIntensity_plot = true;      %绘制标志
sys_param.visualIntensity_savefig = false;  %保存图片标志
sys_param.visualIntensity_allin1 = true;   %绘制到一张图标志

sys_param.AoAAnalysize_RSSthres = 1e-10;    %RSS阀值
sys_param.AoAAnalysize_plotAoA = 1;         %绘制到达角标志
sys_param.AoAAnalysize_plotEnv = 1;         %绘制环境标志
sys_param.recursiveBeamTrace_useArrow = 1;  %使用箭头标志

%src的结构：位置，路径长，反射损失，深度，ID，父亲ID
src = struct('pos', srcPos, 'pathlen', 0, 'refloss', 0,...
    'depth', 0, 'ID', 0, 'parentID', -1);
% sys_param.target.pos = userPos';                %设定目标位置

%计算镜像点位置
% disptitle('Recursion tree for virtual source')
[virSrc, virRF] = findVirtualSrc(env_param, sys_param, src, []);    %调用findVirtualSrc算出virSrc，virRF

%绘制原始点，镜像点，反射面
% disptitle('Visualizing setup')
virSrc = [src virSrc];  %现在的virSrc的前半部分是src
virRF = [struct('info',[], 'ref', [], 'ID', 0) virRF];
%绘制信号强度图
% disptitle('Visualizing signal intensity');
% [plotdata, area_data] = visualIntensity(env_param, sys_param, virSrc, virRF);

% plotSysSetup(env_param, sys_param, virRF, virSrc);   %绘制环境
param.env_param=env_param;
param.sys_param=sys_param;
param.virSrc=virSrc;
param.virRF=virRF;