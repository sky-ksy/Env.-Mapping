function [sortId2, PtCdir, Cpos ] = Kmeans( point,sortN )
%KMEANS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
 [Idx,C,sumD]=kmeans(point,sortN);
 sortId2=Idx;
 PtCdir=C;
 Cpos=sumD;
 
 
 

end

