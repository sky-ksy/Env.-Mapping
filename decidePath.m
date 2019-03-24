function [aver_group_sum,path]=decidePath(cor_list_new,num)  
%num>1

[sort_cor,id]=sort(abs(cor_list_new),'descend');  %按绝对值排序
[sort_id,oriOrder]=sort(id(1:num));  %考虑前num个相关系数最大的path id

%对前num个id按照相邻关系建立分组
group_id=1;
group{group_id}=sort_id(1);
for i=1:num-1
    if(sort_id(i+1)==sort_id(i)+1)  %同一group
        group{group_id}=[group{group_id},sort_id(i+1)];       
    else
        group_id=group_id+1;  %新的group
        group{group_id}=sort_id(i+1);
    end
end 
for j=1:length(group)
    row=group{j};
    group_sum(j)=sum(abs(cor_list_new(row))); %path对应的相关系数求和
    [max_v,max_id]=max(abs(cor_list_new(row)));
    max_path(j)=row(max_id);  %每组相关系数最大的path
end
[max_group_sum,max_group_sum_id]=max(group_sum);
group_pathN=length(group{max_group_sum_id});
aver_group_sum=max_group_sum/group_pathN;
path=max_path(max_group_sum_id);  %相关系数求和最大的组内的 相关系数最大的path