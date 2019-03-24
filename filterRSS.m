function [I]=filterRSS(AoA,AoD,RSS)  %过滤Rss为0的项！！！！！

I=find(RSS==0);
% RSS(I)=[];
% AoA(I)=[];
% AoD(I)=[];