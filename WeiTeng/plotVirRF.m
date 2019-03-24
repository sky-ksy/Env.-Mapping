% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     plotVirRF.m                                                         
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function plotVirRF(sys_param, virRF)

hold on

N_ref = length(virRF);  %获取反射面数量存入N_ref

if sys_param.plotVirRF_print
%     fprintf('ID\tend1X\tend1Y\tend2X\tend2Y\trlct\tpen\tref\n')
end
for ii = 1:N_ref
    if isempty(virRF(ii).info)
        continue;
    end
    plot(real(virRF(ii).info(1:2)), imag(virRF(ii).info(1:2)),'LineWidth',4);
    if sys_param.plotVirRF_print
%         fprintf('%.2f\t', virRF(ii).ID, real(virRF(ii).info(1)), imag(virRF(ii).info(1)), ...
%             real(virRF(ii).info(2)), imag(virRF(ii).info(2)), ...
%             imag(virRF(ii).info(3:4)), virRF(ii).ref);
%         fprintf('\n');
    end
end

hold off
