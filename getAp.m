function apPos=getAp(clusters,userPos)
clusterN=length(clusters);
apNum=0;
for c=1:clusterN  %��ÿһ�ص������ӦAP(��һ�ض�ӦTX)
    mat=clusters{c};
    %��һ��ʱ�̣���һ��APӦ��ֻ�յ�0/1��AoA��������಻��ȷ���ͻ��ж��������
    row=size(mat,1);
    if (row==1)  %��ֻ��һ��AoA�Ĵ��޷��󽻵�
        continue;
    end
    %ֻ�������������ߵĽ���
    intersection=[];
    k=0;
    for i=1:row-1
        abs1=abs(abs(mat(i,1))-pi/2);  %����б�ʲ����ڵ����
        abs2=abs(abs(mat(i+1,1))-pi/2);
        t1=mat(i,3);
        pos1=userPos(t1,:);
        t2=mat(i+1,3);
        pos2=userPos(t2,:);
        if(abs1<1e-3 && abs2<1e-3)
            continue;
        elseif(abs1<=1e-3 && abs2>1e-3)
            k2=tan(mat(i+1,1));
            A=[1,0;k2,-1];
            B=[pos1(1);k2*pos2(1)-pos2(2)];
        elseif(abs1>1e-3 && abs2<=1e-3)
            k1=tan(mat(i,1));
            A=[k1,-1;1,0];
            B=[k1*pos1(1)-pos1(2);pos2(1)];
        else
            k1=tan(mat(i,1));
            k2=tan(mat(i+1,1));
            A=[k1,-1;k2,-1];
            B=[k1*pos1(1)-pos1(2);k2*pos2(1)-pos2(2)];
        end
        %         S=solve(['y=',num2str(k1),'*x+',num2str(pos1)],...
        %             ['y=',num2str(k2),'*x+',num2str(pos2)],'x','y');
        k=k+1;
        intersection(k,:)=(A\B)';
    end
    if(~isempty(intersection))
        apNum=apNum+1;
%         apPos(apNum,:)=median(intersection,1,'omitnan');
        apPos(apNum,:)=getGoodAp(intersection);
    end
end
% fprintf('end\n');
