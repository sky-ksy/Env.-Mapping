function [sortId2, PtCdir, Cpos ] = Kmeans( point,sortN )
%KMEANS 此处显示有关此函数的摘要
%   此处显示详细说明
 [Idx,C,sumD]=kmeans(point,sortN);
 sortId2=Idx;
 PtCdir=C;
 Cpos=sumD;
 
 
 

end

