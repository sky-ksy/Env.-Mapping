% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     plotLightArea.m                                                     
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function plotdata = plotLightArea(area_data, sys_param)

N_area_data = length(area_data);    %要绘制的图的数量存入N_area_data
if N_area_data >= 1
    area_size = size(area_data(1).area_s);  %每个光亮图的大小
    plotdata = zeros(area_size);            %创建光亮图的初始空矩阵
    
    for gg = 1:N_area_data      %每个光亮图遍历
        area_s = area_data(gg).area_s;  %获得当前光亮图的[路径长 反射损失]
        for ii = 1:area_size(1)         %每个格子遍历
            for kk = 1:area_size(2)     
                plotdata(ii, kk) = plotdata(ii, kk) + ...   %存入每个格子的颜色信息（反射损失）
                    db2amp(-(getPathLoss(area_s(ii, kk).pathlen)+area_s(ii, kk).refloss));%------损失 变身 信号强度
            end
        end
    end
    
    if sys_param.lightArea_plot == true
        colormap('hot')
        imagesc(flip(plotdata));
        yTicks = get(gca,'YTick');
        stepy = (sys_param.yhigh-sys_param.ylow)/length(yTicks);
        yTicks = sys_param.ylow+stepy:stepy:sys_param.yhigh;
        set(gca,'YTickLabel',num2str(yTicks.'));
        xTicks = get(gca,'XTick');
        stepx = (sys_param.xhigh-sys_param.xlow)/length(xTicks);
        xTicks = sys_param.xlow+stepx:stepx:sys_param.xhigh;
        set(gca,'XTickLabel',num2str(xTicks.'));
    end
end