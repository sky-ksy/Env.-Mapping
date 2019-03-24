function [rpMatrix]=plotRefPoint(figId,refPoint,param)

rpMatrix=[];
for t=1:length(refPoint)
    rp=refPoint{t};  %t时刻的反射点矩阵
    rpMatrix=[rpMatrix;rp];
end

if isempty(rpMatrix)
    fprintf('no rp\n');
    return;
end

maxX=max(rpMatrix(:,1));
minX=min(rpMatrix(:,1));
maxY=max(rpMatrix(:,2));
minY=min(rpMatrix(:,2));

global hasPlotted;
if (~ismember(figId,hasPlotted))
    hasPlotted=union(hasPlotted,figId);
    f=figure(figId); clf(f);
    plotReflector(param.env_param, param.sys_param);
else
    figure(figId);
end
hold on;
plot(rpMatrix(:,1),rpMatrix(:,2),'k.','MarkerSize',5);
% xlow=jade_param.sys_param.xlow;
% xhigh=jade_param.sys_param.xhigh;
% ylow=jade_param.sys_param.ylow;
% yhigh=jade_param.sys_param.yhigh;
% xlim([min(minX,xlow),max(maxX,xhigh)]);
% ylim([min([minY,ylow]),max(25,yhigh)]);  %min(minY,ylow)
xlim([-8,16]);
ylim([-10,20]);