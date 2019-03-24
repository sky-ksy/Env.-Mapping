% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     figHandlerAsssign.m                                                 
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function sys_param = figHandlerAsssign(sys_param)

sys_param.figHandler.visualIntensity = 1;

sys_param.figHandler.plotSysSetup = 100;

sys_param.figHandler.AoAAnalysize = 200;

sys_param.figHandler.CFRAnalysize = 300;

sys_param.figHandler.mobilityAnalysize = 400;

sys_param.figHandler.AoAAoDEst = 500;

%add
%sys_param.figHandler.modPhaseArray = 600;