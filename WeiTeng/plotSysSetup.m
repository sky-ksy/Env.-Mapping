% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     plotSysSetup.m                                                      
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function plotSysSetup(env_param, sys_param, virRF, virSrc)

if sys_param.plotSysSetup
    fg = figure(sys_param.figHandler.plotSysSetup); clf(fg);
    
    plotReflector(env_param, sys_param)
%     disptitle('Virtual reflector');
    plotVirRF(sys_param, virRF)           %∑¥…‰ŒÔ∑÷∂Œ
%     disptitle('Real/virtual source');
    plotVirSrc(sys_param, virSrc)
end