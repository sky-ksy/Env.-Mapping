% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     recursiveBeamTrace.m                                                
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function aod = recursiveBeamTrace(virSrc, virRF, endp, sVirSrcID, plottype) %递归的波束追踪

Srcidx = ([virSrc.ID] == sVirSrcID);    %找到当前镜像点对应在virSrc里的位置
startp = virSrc(Srcidx).pos;            %从virSrc获得该镜像点坐标
if sVirSrcID == 0   %若为源点
    % last reflection
    if plottype >= 2
        arrow('Start', startp, 'Stop', endp, 'Length', 4, 'TipAngle', 10);  %源点为起点，到终点，画箭头
    elseif plottype >= 1
        plot([endp(1) startp(1)], [endp(2) startp(2)], 'Color', 'blue','LineWidth', 2);
    end
    aod = angle(complex(endp(1)-startp(1), endp(2)-startp(2))); %目标点-源点 转换为 离开角
else  %若为镜像点
    RFidx = ([virRF.ID] == sVirSrcID);  %找到对应反射面在virRF里的位置
    ref = virRF(RFidx).info(1:2);       %从virRF获得该反射面起点终点
    [xi,yi] = polyxpoly([endp(1) startp(1)],[endp(2) startp(2)], ...    %镜像点与目标点连线 与 反射面 交点
        real(ref), imag(ref));
    
    if plottype >= 2
        arrow('Start', [xi, yi], 'Stop', endp, 'Length', 4, 'TipAngle', 20);%交点为起点，到终点，画箭头
    elseif plottype >= 1
        plot([endp(1) xi], [endp(2) yi], 'Color', 'blue','LineWidth', 2);
    end
    
    aod = recursiveBeamTrace(virSrc, virRF, [xi, yi], ...%以交点为终点，点集只有该镜像点，的递归波束追踪
        virSrc(Srcidx).parentID, plottype);
end