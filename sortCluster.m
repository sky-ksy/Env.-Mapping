function [sortId]=sortCluster(point,DIS,method,sortN)
D = pdist(point,DIS);
clustTree = linkage(D,method); 
cop=cophenet(clustTree,D);
fprintf('������Ч��%f\n',cop);
% hidx = cluster(clustTree,'criterion','distance','cutoff',1.4);
%�Ƚ�TX�������
sortId = cluster(clustTree,'maxclust',sortN);  %���е��ΪsortN��