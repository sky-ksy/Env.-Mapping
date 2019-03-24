% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     getPathLoss.m                                                       
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function val = getPathLoss(d)

if d>0.1
    val = -20*log10(5e-3/(4*pi*d))-50;
else
    val = -20*log10(5e-3/(4*pi*0.1))-50;
end