function [aver_group_sum,path]=decidePath(cor_list_new,num)  
%num>1

[sort_cor,id]=sort(abs(cor_list_new),'descend');  %������ֵ����
[sort_id,oriOrder]=sort(id(1:num));  %����ǰnum�����ϵ������path id

%��ǰnum��id�������ڹ�ϵ��������
group_id=1;
group{group_id}=sort_id(1);
for i=1:num-1
    if(sort_id(i+1)==sort_id(i)+1)  %ͬһgroup
        group{group_id}=[group{group_id},sort_id(i+1)];       
    else
        group_id=group_id+1;  %�µ�group
        group{group_id}=sort_id(i+1);
    end
end 
for j=1:length(group)
    row=group{j};
    group_sum(j)=sum(abs(cor_list_new(row))); %path��Ӧ�����ϵ�����
    [max_v,max_id]=max(abs(cor_list_new(row)));
    max_path(j)=row(max_id);  %ÿ�����ϵ������path
end
[max_group_sum,max_group_sum_id]=max(group_sum);
group_pathN=length(group{max_group_sum_id});
aver_group_sum=max_group_sum/group_pathN;
path=max_path(max_group_sum_id);  %���ϵ������������ڵ� ���ϵ������path