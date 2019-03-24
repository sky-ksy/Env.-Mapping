
%模拟实测的AoA和RSS
function [simuAoA,simuRSS]=getSimuAoARSS(fMatAoA,fMatRSS)
pattern_array1 = importdata('../getBeamInfo/pattern/pattern1/0.5m/angleBeam.txt');  %1号网卡
T=length(fMatRSS);
for i=1:T
    rss=fMatRSS{i};
    aoa=fMatAoA{i};
    path = round(aoa*60/pi) + 1;
    multiBSV(i,:)=rss*pattern_array1(path,:); %以rss为权重模仿多路径BSV
    simuAoA{i}=resolveAoA(multiBSV(i,:),pattern_array1); %能否保证和rss个数相同？？
    simuRSS{i}=rss;  %如何解析rss？？？
end
