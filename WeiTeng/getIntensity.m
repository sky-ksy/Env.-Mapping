% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     getIntensity.m                                                      
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function val = getIntensity(src, reflector_list, target, reflector_id, excList)

src_pos = src.pos;
src_pathlen = src.pathlen;

if reflector_id > 0
    refid_pos = reflector_list(reflector_id, 1:2);
end
refloss = 0;
N = size(reflector_list,1);
for ii = 1:N
    if sum(excList == ii)>0
        continue;
    end
    ref_pos = reflector_list(ii, 1:2);
    [xi,yi] = polyxpoly([src_pos(1) target(1)],[src_pos(2) target(2)], ...  %源点与目标点连线 与 其他反射面 的交点
        real(ref_pos), imag(ref_pos));
    if ~isempty(xi) %如果存在
        if reflector_id > 0
            [xr,yr] = polyxpoly([src_pos(1) target(1)],[src_pos(2) target(2)], ...  %源点与目标点连线 与 ？？？的交点
                real(refid_pos), imag(refid_pos));
            if (xr-xi)*(xr-src_pos(1))<0 || (yr-yi)*(yr-src_pos(2))<0
                refloss = refloss+getRefLoss(reflector_list(ii, 4));
            end
        else
            refloss = refloss+getRefLoss(reflector_list(ii, 4));
        end
    end
end

pathlen = getPathLen(src_pos, target);

val = struct('pathlen', pathlen, 'refloss', refloss);

