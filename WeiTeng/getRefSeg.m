% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     getRefSeg.m                                                         
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function val = getRefSeg(src_pos, reflector_list, tgRF, excList, incEnd)

% Function usage: when ray originating from src_pos to tgRF, it may blocked
% by reflectors in reflector_list, and be separated into multiple
% segments. Here we drive these multiple segments.


N_list = size(reflector_list, 1);   %反射面的数量

if incEnd   %若incEnd为true
    segx = [real(tgRF(1)) real(tgRF(2))];   %反射面的两x坐标
    segy = [imag(tgRF(1)) imag(tgRF(2))];   %获取反射面的y坐标
else
    segx = [];
    segy = [];
end

for ii = 1:N_list   %每个反射面遍历
    if sum(excList == ii)>0     %跳过第ii个反射面，即当前处理的反射面
        continue;
    end
    
    test_RF = reflector_list(ii, 1:2);  %第ii个反射面存入test_RF
    %点1=源点-目标反射面起点连线 与 第ii反射面 的交点
    [p1x, p1y] = polyxpoly([src_pos(1) real(tgRF(1))],[src_pos(2) imag(tgRF(1))], ...
        real(test_RF), imag(test_RF));
     %点2=源点-目标反射面终点连线 与 第ii反射面 的交点
    [p2x, p2y] = polyxpoly([src_pos(1) real(tgRF(2))],[src_pos(2) imag(tgRF(2))], ...
        real(test_RF), imag(test_RF)); 
                                           
    if ~isempty(p1x)        %若点1存在
        p1x = real(tgRF(1));%点1x为目标反射面起点x
        p1y = imag(tgRF(1));%点1y为目标反射面起点y
    end
    if ~isempty(p2x)        %若点2存在
        p2x = real(tgRF(2));%点2x为目标反射面终点x
        p2y = imag(tgRF(2));%点2y为目标反射面终点y
    end

    % multiple 999999 equals to the effect of extending the line very long,
    % to make sure that the line is intersecting with the target reflector,
    % if exists.
    %点3=源点与第ii反射面起点连线的延长线 与 目标反射面 的交点
    [p3x, p3y] = polyxpoly([src_pos(1) (real(test_RF(1))-src_pos(1))*999999], ...
        [src_pos(2) (imag(test_RF(1))-src_pos(2))*999999], ...
        real(tgRF), imag(tgRF));
    %点4=源点与第ii反射面终点连线的延长线 与 目标反射面 的交点
    [p4x, p4y] = polyxpoly([src_pos(1) (real(test_RF(2))-src_pos(1))*999999], ...
        [src_pos(2) (imag(test_RF(2))-src_pos(2))*999999], ...
        real(tgRF), imag(tgRF));
    
    if length([p1x p2x p3x p4x]) >= 2   %若点1234至少有两个存在，则分段
        segx = [segx, p1x, p2x, p3x, p4x];
        segy = [segy, p1y, p2y, p3y, p4y];
    end
end

%若x的差值大于y的差值（-1<斜率<1）
if abs(real(tgRF(1))-real(tgRF(2))) > abs(imag(tgRF(1))-imag(tgRF(2)))
    [segx, ia] = unique(round(segx,2)); %segx中的值都精确到小数点后两位，排序并去掉重复值
    segy = segy(ia);
else
    [segy, ia] = unique(round(segy,2)); %segy中的值都精确到小数点后两位，排序并去掉重复值
    segx = segx(ia);
end
    
val = [segx; segy]; %得出分段点
    