function [sortId]=sortCluster(point,DIS,method,sortN)
D = pdist(point,DIS);
clustTree = linkage(D,method); 
cop=cophenet(clustTree,D);
fprintf('聚类树效果%f\n',cop);
% hidx = cluster(clustTree,'criterion','distance','cutoff',1.4);
%先将TX分类出来
sortId = cluster(clustTree,'maxclust',sortN);  %所有点分为sortN类