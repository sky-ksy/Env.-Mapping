% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     mirrorPoint.m                                                       
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function val = mirrorPoint(p, line)
% p = [m, n]
% line = [x1+y1*i, x2+y2*i]
% val = [t, s]

x1 = real(line(1));
x2 = real(line(2));
y1 = imag(line(1));
y2 = imag(line(2));
m = p(1);
n = p(2);

t = (2*(x1-m)*(y1-y2)^2+2*(n-y1)*(x1-x2)*(y1-y2))/((x1-x2)^2+(y1-y2)^2)+m;
s = (2*(y1-n)*(x1-x2)^2+2*(m-x1)*(y1-y2)*(x1-x2))/((x1-x2)^2+(y1-y2)^2)+n;

val = [t, s];
