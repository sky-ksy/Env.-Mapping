function AA = row2triu(D)
m=length(D); % m为行向量元素的个数
n=(1+sqrt(1+8*m))/2; % 根据二次函数的求根公式，计算向量对应的上三角矩阵的维数，对角元为0.
AA=zeros(n,n);

% 以下把向量转化为上三角
index =1;
for i=1:n
    for j=i+1:n
        AA(i,j)=D(index);
        index = index+1;
    end
end

% 下三角替换
AA = triu(AA);
AA = AA+AA';

% 主元变为1
AA(eye(size(AA))~=0)=NaN;
% pcolor(AA);colorbar;
end