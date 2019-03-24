function refPoint=getTrueRefPoint(param,aviApId,userPos)
apN=length(aviApId);
ap=zeros(apN,2);
for ii=1:apN
    id=aviApId(ii);
    ap(ii,:)=param.virSrc(id).pos;
end
userN=size(userPos,1);
refPoint=cell(apN-1,1);  %每个cell包含相应Vap对应的反射点
for i=2:apN
    for j=1:userN
        abs1=abs(ap(1,2)-ap(i,2));  %考虑斜率不存在的情况
        abs2=abs(userPos(j,1)-ap(i,1));
        midpoint=[ap(1,1)+ap(i,1),ap(1,2)+ap(i,2)]./2;
        if(abs1<1e-3 && abs2<1e-3)  %两个斜率都不存在时无法求交点
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