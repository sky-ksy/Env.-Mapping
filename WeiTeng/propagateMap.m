% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     propagateMap.m                                                      
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function area_s = propagateMap(env_param, sys_param, inVirSrc, inVirRF)

src_pos = inVirSrc.pos; %获得源点坐标保存到src_pos

if isempty(inVirRF) || isempty(inVirRF.info)    %若inVirRF为空 或 inVirRF.info为空
    reflector_id = -1;                          %令reflector_id = -1
else
    reflector_id = inVirRF.ref;
end
reflector_list = env_param.reflector_list;      %从环境参数中获得原反射物列表存入reflector_list

[area_s, area_c] = initializemap(sys_param);    %area_s为[路径长，反射损失]
                                                %area_c为系统xy的所有值

if reflector_id == -1
    % to all directionss
    area_size = size(area_s);   %area_sise为[y格子数 x格子数]
    for ii = 1:area_size(1)
        for kk = 1:area_size(2) %每格子进行遍历
            area_s(ii, kk) = getIntensity(inVirSrc, ... %计算每个格子的信号强度
                reflector_list, [area_c.x(kk), area_c.y(ii)], reflector_id, []);    
        end
    end
else
    refmir = inVirRF.info(1:2); %反射物起点终点坐标存入refmir
    
    area_size = size(area_s);   %area_sise为[y格子数 x格子数]
    for ii = 1:area_size(1)
        for kk = 1:area_size(2)
            target = [area_c.x(kk), area_c.y(ii)];  %第[kk,ii]个格子的坐标存入target
            
            [xi,~] = polyxpoly([src_pos(1) target(1)],[src_pos(2) target(2)], ...
                real(refmir), imag(refmir));    %计算 源点和target格子连线 与 反射面 的交点 的x值
            if ~isempty(xi) %若存在交点，说明在反射面两侧，有损失
                % instant penetration loss and accumulated transmission loss
                area_s(ii, kk) = getIntensity(inVirSrc, reflector_list, ... %计算该格子信号强度，得出路径长和损失
                [area_c.x(kk), area_c.y(ii)], reflector_id, reflector_id);
                % accumulated reflection and penetration loss
                area_s(ii, kk).refloss = area_s(ii, kk).refloss+inVirSrc.refloss;   %累加源点本身损失
            else    %没有交点，在反射面同侧，无损失
                area_s(ii, kk) = struct('pathlen', inf, 'refloss', 0);
                continue;
            end
        end
    end
end

end