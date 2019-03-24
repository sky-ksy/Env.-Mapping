
function simuAoA=resolveAoA(multiBSV,pattern_array)
pathCoe=25;  %与提取路径数目有关的参数
useGroup=1;  %是否使用选举法
max_cor_num=10;  %选举人数

row=size(multiBSV,1);
esti_angle_array = cell(row,1);  %存储AoD提取结果

for xx = 1:row
    fprintf('current group id:%d\n',xx);
    
    multi_path_bsv_ori = multiBSV(xx,:);
    multi_path_bsv_ori1 = multiBSV(xx,:);
    
    pre_angle_list = [];
    pre_path=[];
    cor_list = [];
    % 提取第一个角度，一定有，至少有一条路径
    for angle_id = 1:61  %各个角度beam序列与测得beam序列的相关性
        temp_cor = corrcoef(multi_path_bsv_ori,pattern_array(angle_id,:));
        cor_list = [cor_list temp_cor(1,2)];
    end
    if useGroup
        [max_cor,max_path]=decidePath(cor_list,max_cor_num);
    else
        [max_cor,max_path] = max(abs(cor_list));  %相关性绝对值最大对应的path
    end
    pre_angle_list = [pre_angle_list (max_path-1)*3];  %第一条路径对应的角度
    pre_path=[pre_path max_path]; %第一条路径对应的路径id
    [sort_cor,sort_angleId]=sort(abs(cor_list),'descend');  %按绝对值排序
    
    %正负相关情形下weight范围的确定
    if(cor_list(max_path)>0)  %与该角度的BSV正相关
        if(min(multi_path_bsv_ori)<0)
            fprintf(2,'初始RSS为负\n');
        end
        weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %大于0
        min_weight=0;
        max_weight=max(weight_list);
    elseif(cor_list(max_path)<0)  %与该角度的BSV负相关
        fprintf('首次最大相关性为负\n');
        %转化为正相关，并使BSV取正值
        multi_path_bsv_ori=-multi_path_bsv_ori;
        multi_path_bsv_ori=multi_path_bsv_ori-min(multi_path_bsv_ori)+1000;
        weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %大于0
        min_weight=0;
        max_weight=max(weight_list);
    else
        fprintf('首次最大相关性为0\n');
    end
    
    min_percent=0.05;
    left_percent = 1;
    percent_array=left_percent;% 剩余的bsv的信号强度 占原信号平均强度的百分比
    
    %每次循环提取一个角度
    pathN=0;
    while true
        pathN=pathN+1;
        cor_min = 1;
        good_weight=max_weight;     
        for ii = max_weight/100:max_weight/100:max_weight
            % 一点，一点减去权重最大的路径
            multi_path_bsv_ori_temp = multi_path_bsv_ori - ii*(pattern_array(max_path,:));
            remain_cor=corrcoef(multi_path_bsv_ori_temp,(pattern_array(max_path,:)));
            % 找出相关性里最近接0的，并记录下减去的主路径的权重
            if abs(abs(remain_cor(1,2))-cor_min)<1e-3  %是否有多个合适的weight
                fprintf(2,'pathN=%d,weighti=%f,cor=%f\n',pathN,ii,remain_cor(1,2));
            elseif abs(remain_cor(1,2)) < cor_min
                cor_min = abs(remain_cor(1,2));
                good_weight = ii;
                %                 fprintf(2,'minus_weight:%f cor_min:%f\n',minus_weight,cor_min);
            else
                %                 fprintf('weight:%f cor_min:%f\n',ii,abs(remain_cor(1,2)));
            end
        end
        
        %剩余BSV与各角度BSV的相关性
        cor_list_temp = [];
        multi_path_bsv_ori_temp=multi_path_bsv_ori - good_weight*(pattern_array(max_path,:));
        for angle_id = 1:61
            temp_cor = corrcoef(multi_path_bsv_ori_temp,(pattern_array(angle_id,:)));
            cor_list_temp = [cor_list_temp temp_cor(1,2)];
        end
        cor_list_new = cor_list_temp;
        [sort_cor,id]=sort(abs(cor_list_new),'descend');  %按绝对值排序
        
        % 减去上一个主路径的权重，求新的路径角度
        multi_path_bsv_ori = multi_path_bsv_ori - good_weight*(pattern_array(max_path,:));
        left_percent = mean(multi_path_bsv_ori)/mean(multi_path_bsv_ori1);  %剩余的占原始的比例
        percent_array=[percent_array left_percent];
        if useGroup
            [max_v,max_path]=decidePath(cor_list_new,max_cor_num);
        else
            [max_v,max_path] = max(abs(cor_list_new));
        end
        max_cor=[max_cor max_v];
        % sum(abs(cor_list_new))
        if(max_v>sum(abs(cor_list_new))/pathCoe)  %剩余的BSV与各角度BSV是否有足够相关性
            pre_angle_list = [pre_angle_list (max_path-1)*3];  %路径对应的角度
            pre_path=[pre_path max_path];  %路径对应的路径id
        else
            break;
        end
        
        %新的角度有足够的相关性则重新确定weight范围
        if(cor_list_new(max_path)>0)  %与该角度的BSV正相关
            if(min(multi_path_bsv_ori)<0)
                multi_path_bsv_ori=multi_path_bsv_ori-min(multi_path_bsv_ori)+1000;
                fprintf('path%d最小BSV为负\n',pathN+1);
            end
            weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %大于0
            min_weight=0;
            max_weight=max(weight_list);
        elseif(cor_list_new(max_path)<0)
            fprintf('path%d最大相关性为负\n',pathN+1);
            %转化为正相关，并使BSV取正值
            multi_path_bsv_ori=-multi_path_bsv_ori;
            multi_path_bsv_ori=multi_path_bsv_ori-min(multi_path_bsv_ori)+1000;
            weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %大于0
            min_weight=0;
            max_weight=max(weight_list);
        else
            fprintf('最大相关性为0\n');
        end
    end
    
%     esti_angle_array{xx} =pre_angle_list;
    simuAoA = unique(pre_angle_list);
end

