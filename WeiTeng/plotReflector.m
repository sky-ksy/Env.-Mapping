% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     plotReflector.m                                                     
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function plotReflector(env_param, sys_param)

hold on
reflector_list = env_param.reflector_list;

N_ref = size(reflector_list, 1);

for ii = 1:N_ref
    plot(real(reflector_list(ii, 1:2)), imag(reflector_list(ii, 1:2)), 'Color',[1 0.5 0],'LineWidth',4);
end

axis equal
xlim([sys_param.xlow sys_param.xhigh])
ylim([sys_param.ylow sys_param.yhigh]);

hold off
