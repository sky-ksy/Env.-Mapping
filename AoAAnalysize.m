% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     AoAAnalysize.m                                                      
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function [AoA,ARSS,AoD] = AoAAnalysize(env_param, sys_param, virSrc, virRF)

sys_param_ = sys_param;             %获取系统参数
target_pos = sys_param_.target.pos; %获取目标位置

sys_param_.visualIntensity_plot = false;    %绘制强度标志
sys_param_.visualIntensity_savefig = false; %保存图像标志
sys_param_.visualIntensity_allin1 = false;  %绘制一图标志
sys_param_.xlow = target_pos(1);                            %x轴最小值
sys_param_.xhigh = target_pos(1)+0.45*sys_param_.gridsize;  %x轴最大值
sys_param_.ylow = target_pos(2);                            %y轴最小值
sys_param_.yhigh = target_pos(2)+0.45*sys_param_.gridsize;  %y轴最大值-----------将目标点看作一个格子

if sys_param.AoAAnalysize_plotEnv || sys_param.AoAAnalysize_plotAoA     
    fii = figure(sys_param.figHandler.AoAAnalysize); clf(fii);
%     figure('Visible','off');
end

if sys_param.AoAAnalysize_plotEnv       %绘制环境标志
%     if sys_param.AoAAnalysize_plotAoA   %绘制AoA标志
%         subplot(2,1,1)
%     end
    sys_param_.plotVirRF_print = false;
    plotVirRF(sys_param_, virRF);       %输出并绘制所有反射面
    sys_param_.plotVirSrc_print = false;
    plotVirSrc(sys_param_, virSrc(1));  %绘制源点
    hold on
    plot(target_pos(1), target_pos(2), 'r.')    %绘制目标点
    axis equal
    xlim([sys_param.xlow sys_param.xhigh])
    ylim([sys_param.ylow sys_param.yhigh]);
end

AoA = [];   %到达角
AoD = [];   %离开角
ARSS = [];  %接收信号强度
APlen = []; %路径长度

[plotdata, area_data] = visualIntensity(env_param, sys_param_, virSrc, virRF);  %[光亮强度][路径长，反射损失]
idx = find([plotdata.data] > sys_param_.AoAAnalysize_RSSthres);     %找到大于RSS阈值的data
N = length(idx);    %计算个数存入N
if sys_param.AoAAnalysize_plotEnv
%     fprintf('Recursive beam tracing: \n');
    parfor_progress(N);
end
% j=1;
for ii = idx    %每个大于RSS阈值的data遍历
    AoA(ii) = angle(complex(virSrc(ii).pos(1)-target_pos(1), ...%源点坐标-目标点坐标 转换为 到达角
        virSrc(ii).pos(2)-target_pos(2)));
    if sys_param.AoAAnalysize_plotEnv
        aod_ = recursiveBeamTrace(virSrc, virRF, target_pos, ...    %以目标点为终点的递归的波束追踪，返回离开角
            virSrc(ii).ID, sys_param.recursiveBeamTrace_useArrow+...
            sys_param.AoAAnalysize_plotEnv);
        %plot([virSrc(ii).pos(1) target_pos(1)], [virSrc(ii).pos(2) ...
        %target_pos(2)], 'Color', 'blue','LineWidth', 2)
        parfor_progress;
    else
        aod_ = recursiveBeamTrace(virSrc, virRF, target_pos, virSrc(ii).ID, 0);
    end
    AoD(ii) = aod_; %保存离开角
    ARSS(ii) = plotdata(ii).data(1);    %保存RSS
    APlen(ii) = area_data(ii).area_s(1,1).pathlen;  %保存路径长
    
%     ToA(ii)=APlen(ii)/3e8*1e9;  %保存到达时间
%     ToA(j)=ToA(ii);
%     finalAoA(j)=AoA(ii);  %记录满足信号强度要求的AoA与virSrc
%     finalARSS(j)=ARSS(ii);
%     finalAoD(j)=AoD(ii);
%     virS(j)=virSrc(ii);
%     j=j+1;
end

if sys_param.AoAAnalysize_plotEnv
    parfor_progress(0);
end

if sys_param.AoAAnalysize_plotEnv
    hold off
end

% if sys_param.AoAAnalysize_plotAoA
%     if sys_param.AoAAnalysize_plotEnv
%         subplot(2,1,2)
%     end
%     plot(AoA/pi*180, ARSS, 'ro'); hold on;
%     plot(AoD/pi*180, ARSS, 'bx'); hold off;
%     xlim([-180 180]);
%     xlabel('Angle of arrival/departure (deg.)')
%     ylabel('Amplitude')
%     legend('AoA', 'AoD');
%     
%     
%     
%     
%     %{
% fii = figure(sys_param.figHandler.AoAAnalysize+10); clf(fii);
%     % joint AoA,AoD,DoA plot
%     [X, Y] = meshgrid(-180:180,-180:180);
%     xidx = round(AoA/pi*180)+181;
%     yidx = round(AoD/pi*180)+181;
%     Z = zeros(size(X));
%     for ii = 1:length(xidx)
%         Z(yidx(ii), xidx(ii)) = APlen(ii)/3e8*1e9;  %路径长转换成时延，单位为纳秒
%     end
%     plot3(X,Y,Z,'LineWidth',3);
%     xlim([-180 180])
%     ylim([-180 180])
%     xlabel('AoA (deg.)')
%     ylabel('AoD (deg.)')
%     zlabel('delay (ns)')
%     %}
% end

