% /*************************************************************************************
%
%    Program:       Millimeter Wave Raytracing Simulator
%    File Name:     main.m
%    Authors:       Teng Wei
%    Contact:       twei7@wisc.edu
%    Version:       1.2
%    Date:          July 03, 2015  1:52PM
%
%    Update:        add 3-D reflection and device orientation
%    Author:        Anfu Zhou
%    Date:          Feb 2017
%  *************************************************************************************

clc; clear all;
warning off;
pathSetup

%src�Ľṹ��λ�ã�·������������ʧ����ȣ�ID������ID
src = struct('pos', [0 0], 'pathlen', 0, 'refloss', 0,...
    'depth', 0, 'ID', 0, 'parentID', -1);

%���������еķ�����ṹ����㣬�յ㣬�����ʣ���͸
% location1, location2, reflectivity, penetration

% env_param.reflector_list = ...      %��������������������
%     [0.5-1i, 1.5-1i, 1, 0;
%      2+0i,   2-2i, 1, 0;
%      0+2i, -1+1i, 1.0, 0.0;
%      -2-3i, -2+0.5i, 1.0, 0.0;
%      1+2i, 2+1i, 1.0, 0.0;
%      -0.5-0.5i, -0.5+0.5i, 1.0, 0.0];

env_param.reflector_list = ...      %��������һ��6*4�ıڷ���
    [-3-1.5i, -3+2.5i, 1, 0;
    -3+2.5i,   3+2.5i, 1, 0;
    3+2.5i, 3-1.5i, 1.0, 0.0;
    3-1.5i, -3-1.5i, 1.0, 0.0;
    ];
env_param.reflector_id = -1;        %������ID��ʼΪ-1
env_param.exclude_list = [];        %�ų����б�

%����ϵͳ����
sys_param.xlow = -3; sys_param.xhigh = 3;       %x�᷶Χ
sys_param.ylow = -1.5; sys_param.yhigh = 2.5;   %y�᷶Χ
sys_param.gridsize = 0.1;                       %�����С
sys_param.virSrcN = 0;                          %virsrc����
sys_param.target.pos = [-2, 2];              %Ŀ��λ��
sys_param.target.RF = 60e9:1e6:61e9;            %Ŀ��Ƶ��
sys_param = figHandlerAsssign(sys_param);

%���㾵���λ��
disptitle('Recursion tree for virtual source')
sys_param.rec_depth = 1;
sys_param.max_recDepth = 1;
[virSrc, virRF] = findVirtualSrc(env_param, sys_param, src, []);    %����findVirtualSrc���virSrc��virRF

%����ԭʼ�㣬����㣬������
disptitle('Visualizing setup')
sys_param.plotSysSetup = true;
sys_param.plotVirRF_print = true;
sys_param.plotVirSrc_print = true;
virSrc = [src virSrc];  %���ڵ�virSrc��ǰ�벿����src
virRF = [struct('info',[], 'ref', [], 'ID', 0) virRF];
plotSysSetup(env_param, sys_param, virRF, virSrc);      %���ƻ�������

%�����ź�ǿ��ͼ
disptitle('Visualizing signal intensity');
sys_param.visualIntensity_parRun = false;   %ƽ�����б�־
sys_param.visualIntensity_plot = true;      %���Ʊ�־
sys_param.visualIntensity_savefig = false;  %����ͼƬ��־
sys_param.visualIntensity_allin1 = true;   %���Ƶ�һ��ͼ��־
%[plotdata, area_data] = visualIntensity(env_param, sys_param, virSrc, virRF);


disptitle('AoA analysis');
sys_param.AoAAnalysize_RSSthres = 1e-10;    %RSS��ֵ
sys_param.AoAAnalysize_plotAoA = 1;         %���Ƶ���Ǳ�־
sys_param.AoAAnalysize_plotEnv = 1;         %���ƻ�����־
sys_param.recursiveBeamTrace_useArrow = 1;  %ʹ�ü�ͷ��־
[AoA,virS,ARSS,AoD] = AoAAnalysize(env_param, sys_param, virSrc, virRF);  %�ź�ǿ�ȴ���ĳһ��ֵ��AoA

%JADE
[X,y]=Jade(AoA,ARSS,virS);
n=size(X,2);
fprintf('final MSE:');
m=testMSE(X,AoA,1,y)
for i=1:n
    tAoA(i) = angle(complex(X(1,i)-y(1), ...%Դ������-Ŀ������� ת��Ϊ �����
X(2,i)-y(2)));
end
[adoa,Ri]=generateR(tAoA,3,n);
%���Դ���1
% n=length(virSrc);
% fprintf('pR,mT\n');  %mR,mT:9�����㣬3��С��1�� pR,pT 2��0�� mR,pTȫ�㣻pR,mT 9�����㣬4��С��0��
% for i=1:n
%     for j=[1:i-1,i+1:n]
%         %theta=abs(AoA(j)-AoA(i));%myT
%         theta=AoA(j)-AoA(i);%paperT
%         beta=pi/2-theta;
%         %R=[cos(beta),sin(beta);-sin(beta),cos(beta)]; %paperR
%         R=[cos(beta),-sin(beta);sin(beta),cos(beta)];%myR
%         y=sys_param.target.pos;
%         xi=virSrc(i).pos;
%         xj=virSrc(j).pos;
%         vi=2*(y-xi)/(norm(y-xi))^2;
%         bi=2*sin(theta);
%         sub=vi*R*(xj-xi)'-bi;
%         %         xi=X(:,i);
%         %         xj=X(:,j);
%         %         vi=2*(y-xi)/(norm(y-xi))^2;
%         %         bi=2*sin(theta);
%         %         sub=vi'*R*(xj-xi)-bi;
%         fprintf('i=%d,j=%d,sub=%f\n',i,j,sub);
%     end
% end
%���Դ���2
% n=length(virSrc);
% X=zeros(2,n);
% for i=1:n
%    X(:,i)=virSrc(i).pos';
% end
% testX(X,AoA,sys_param);
% X
% for i=1:n
%     Xii=transCol(X,i,n);
%     [thetai,Ri]=generateR(AoA,i,n);
%     Mi=squeeze(sum(Ri .* shiftdim(Xii, -1), 2));
%     bi=2*sin(thetai);
%     y=sys_param.target.pos';
%     vi=2*(y-X(:,i))/(norm(y-X(:,i)))^2;
%     sub=vi'*Mi-bi
% end
return;
