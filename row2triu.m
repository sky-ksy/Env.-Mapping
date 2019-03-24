function AA = row2triu(D)
m=length(D); % mΪ������Ԫ�صĸ���
n=(1+sqrt(1+8*m))/2; % ���ݶ��κ����������ʽ������������Ӧ�������Ǿ����ά�����Խ�ԪΪ0.
AA=zeros(n,n);

% ���°�����ת��Ϊ������
index =1;
for i=1:n
    for j=i+1:n
        AA(i,j)=D(index);
        index = index+1;
    end
end

% �������滻
AA = triu(AA);
AA = AA+AA';

% ��Ԫ��Ϊ1
AA(eye(size(AA))~=0)=NaN;
% pcolor(AA);colorbar;
end