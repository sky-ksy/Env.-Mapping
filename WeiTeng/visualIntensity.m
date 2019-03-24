% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     visualIntensity.m                                                   
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function [plotdata, area_data] = visualIntensity(env_param, sys_param, virSrc, virRF)

NvirSrc = length(virSrc);   %虚拟源点数量存入NvirSrc
if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
%     fprintf('Fetching intensity distribution: \n');
    parfor_progress(NvirSrc);
end
sys_param.lightArea_plot = sys_param.visualIntensity_plot;

if sys_param.visualIntensity_parRun == true     %如果并行运行标志==true
    parfor ii = 1:NvirSrc   %每个源点+虚拟源点遍历
        area_data(ii).area_s = propagateMap(env_param, sys_param, virSrc(ii), virRF(ii));%计算第ii源点的[路径长 反射损失]
        if sys_param.visualIntensity_allin1 == false
            if sys_param.visualIntensity_plot == true
                fii_par = figure(sys_param.figHandler.visualIntensity+ii-1); clf(fii_par);  %创建窗口，返回句柄
            end
            plotdata(ii).data = plotLightArea(area_data(ii), sys_param);    %绘制每一个源点所造成的光亮
            if sys_param.visualIntensity_savefig == true
                saveas(fii_par, sprintf('./figures/%d.png',ii));
                close(fii_par);
            end
        end
        if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
            parfor_progress;
        end
    end
else    %并行运行标志==false
    for ii = 1:NvirSrc      %每个源点+虚拟源点遍历
        area_data(ii).area_s = propagateMap(env_param, sys_param, virSrc(ii), virRF(ii));%计算第ii个镜像点的[路径长 反射损失]
        if sys_param.visualIntensity_allin1 == false
            if sys_param.visualIntensity_plot == true
                fii = figure(sys_param.figHandler.visualIntensity+ii-1); clf(fii);%创建窗口，返回句柄
            end
            plotdata(ii).data = plotLightArea(area_data(ii), sys_param); %绘制该源点所造成的每个格子的光亮
            if sys_param.visualIntensity_savefig == true
                saveas(fii, sprintf('./figures/%d.png',ii));
                close(fii);
            end
        end
        if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
            parfor_progress;
        end
    end
end

if sys_param.visualIntensity_allin1 == true  %画在一图中
    if sys_param.visualIntensity_plot == true
        fii = figure(sys_param.figHandler.visualIntensity); clf(fii);
    end
    plotdata.data = plotLightArea(area_data, sys_param);%信号的影响叠加不能直接加，影响可能正可能负
    if sys_param.visualIntensity_savefig == true
        saveas(fii, sprintf('./figures/allin1.png'));
        close(fii);
    end
end

if ~isfield(sys_param, 'visualIntensity_progress_enable') || ...
        sys_param.visualIntensity_progress_enable
    parfor_progress(0);
end