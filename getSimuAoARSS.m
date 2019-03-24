
%ģ��ʵ���AoA��RSS
function [simuAoA,simuRSS]=getSimuAoARSS(fMatAoA,fMatRSS)
pattern_array1 = importdata('../getBeamInfo/pattern/pattern1/0.5m/angleBeam.txt');  %1������
T=length(fMatRSS);
for i=1:T
    rss=fMatRSS{i};
    aoa=fMatAoA{i};
    path = round(aoa*60/pi) + 1;
    multiBSV(i,:)=rss*pattern_array1(path,:); %��rssΪȨ��ģ�¶�·��BSV
    simuAoA{i}=resolveAoA(multiBSV(i,:),pattern_array1); %�ܷ�֤��rss������ͬ����
    simuRSS{i}=rss;  %��ν���rss������
end
