function plotRP(figId,refPoint,param)

if isempty(refPoint)
    fprintf('no rp\n');
    return;
end

global hasPlotted;
if (~ismember(figId,hasPlotted))
    hasPlotted=union(hasPlotted,figId);
    f=figure(figId); clf(f);
    plotReflector(param.env_param, param.sys_param);
else
    figure(figId);
end
hold on;
plot(refPoint(:,1),refPoint(:,2),'k.','MarkerSize',12);

% plot(refPoint(:,1),refPoint(:,2),'k.','MarkerSize',12);
% xlim([-8,16]);
% ylim([-10,20]);
xlim([-3,11]);
ylim([-2,12]); 

