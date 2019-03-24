function AoA=genErrorAoA(AoA,RSS)
oriAoA=AoA;
n=length(AoA);
rd=rand(1,n);
sig=zeros(1,n)-1;
sig(rd>0.5)=1; %角度的正负偏差

% pian1=intersect(find(0.06<=RSS) ,find(RSS<0.12)); %大概1m-2m
% AoA(pian1)=AoA(pian1)+sig(pian1).*(zeros(1,length(pian1))+pi/180); %偏差1度
% pian2=intersect(find(0.04<=RSS) ,find(RSS<0.06)); %大概2m-3m
% AoA(pian2)=AoA(pian2)+sig(pian2).*(zeros(1,length(pian2))+1.5*pi/180); %偏差2度
% pian3=intersect(find(0.03<=RSS) ,find(RSS<0.04)); %大概3m-4m
% AoA(pian3)=AoA(pian3)+sig(pian3).*(zeros(1,length(pian3))+2*pi/180); %偏差3度
pian3=find(0.03<=RSS); %大概4m-5m
AoA(pian3)=AoA(pian3)+sig(pian3).*(zeros(1,length(pian3))+1*pi/180); %偏差4度
pian4=intersect(find(0.01<=RSS) ,find(RSS<0.03)); %大概4m-5m
AoA(pian4)=AoA(pian4)+sig(pian4).*(zeros(1,length(pian4))+2*pi/180); %偏差4度
pian5=find(RSS<0.01); %大于5m
AoA(pian5)=AoA(pian5)+sig(pian5).*(zeros(1,length(pian5))+2*pi/180); %偏差5度

gtPi=find(AoA>pi);
AoA(gtPi)=AoA(gtPi)-2*pi;
leqNegPi=find(AoA<=-pi);
AoA(leqNegPi)=AoA(leqNegPi)+2*pi; %范围限制在（-pi,pi]

