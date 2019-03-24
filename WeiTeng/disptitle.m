% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     disptitle.m                                                         
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function disptitle(str)

len = length(str);
N = 60;
lN = floor((N-len-2)/2);
rN = ceil((N-len-2)/2);

fprintf('\n');
disp([repmat('-', 1, lN), sprintf(' %s ', str), repmat('-', 1, rN)]);