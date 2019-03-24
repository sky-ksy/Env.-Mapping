function refPoint=getRefPoint(ap,userPos,clusters)
apN=size(ap,1);
refPoint=cell(apN-1,1);  %ÿ��cell������ӦVap��Ӧ�ķ����
for i=2:apN
    mat=clusters{i};
    idx=mat(:,3)';
    for j=idx
        abs1=abs(ap(1,2)-ap(i,2));  %����б�ʲ����ڵ����
        abs2=abs(userPos(j,1)-ap(i,1));
        midpoint=[ap(1,1)+ap(i,1),ap(1,2)+ap(i,2)]./2;
        if(abs1<1e-3 && abs2<1e-3)  %����б�ʶ�������ʱ�޷��󽻵�
            continue;
        elseif(abs1<=1e-3 && abs2>1e-3)
            uVapK=(userPos(j,2)-ap(i,2))/(userPos(j,1)-ap(i,1));
            A=[1,0;uVapK,-1];
            B=[midpoint(1);uVapK*userPos(j,1)-userPos(j,2)];            
        elseif(abs1>1e-3 && abs2<=1e-3)
            bisectorK=-(ap(1,1)-ap(i,1))/(ap(1,2)-ap(i,2));
            A=[bisectorK,-1;1,0];
            B=[bisectorK*midpoint(1)-midpoint(2);userPos(j,1)];
        else
            bisectorK=-(ap(1,1)-ap(i,1))/(ap(1,2)-ap(i,2));
            uVapK=(userPos(j,2)-ap(i,2))/(userPos(j,1)-ap(i,1));
            A=[bisectorK,-1;uVapK,-1];
            B=[bisectorK*midpoint(1)-midpoint(2);uVapK*userPos(j,1)-userPos(j,2)];
        end
        refPoint{i-1}=[refPoint{i-1};[(A\B)',j]];
    end
end