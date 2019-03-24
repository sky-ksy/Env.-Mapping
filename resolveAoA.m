
function simuAoA=resolveAoA(multiBSV,pattern_array)
pathCoe=25;  %����ȡ·����Ŀ�йصĲ���
useGroup=1;  %�Ƿ�ʹ��ѡ�ٷ�
max_cor_num=10;  %ѡ������

row=size(multiBSV,1);
esti_angle_array = cell(row,1);  %�洢AoD��ȡ���

for xx = 1:row
    fprintf('current group id:%d\n',xx);
    
    multi_path_bsv_ori = multiBSV(xx,:);
    multi_path_bsv_ori1 = multiBSV(xx,:);
    
    pre_angle_list = [];
    pre_path=[];
    cor_list = [];
    % ��ȡ��һ���Ƕȣ�һ���У�������һ��·��
    for angle_id = 1:61  %�����Ƕ�beam��������beam���е������
        temp_cor = corrcoef(multi_path_bsv_ori,pattern_array(angle_id,:));
        cor_list = [cor_list temp_cor(1,2)];
    end
    if useGroup
        [max_cor,max_path]=decidePath(cor_list,max_cor_num);
    else
        [max_cor,max_path] = max(abs(cor_list));  %����Ծ���ֵ����Ӧ��path
    end
    pre_angle_list = [pre_angle_list (max_path-1)*3];  %��һ��·����Ӧ�ĽǶ�
    pre_path=[pre_path max_path]; %��һ��·����Ӧ��·��id
    [sort_cor,sort_angleId]=sort(abs(cor_list),'descend');  %������ֵ����
    
    %�������������weight��Χ��ȷ��
    if(cor_list(max_path)>0)  %��ýǶȵ�BSV�����
        if(min(multi_path_bsv_ori)<0)
            fprintf(2,'��ʼRSSΪ��\n');
        end
        weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %����0
        min_weight=0;
        max_weight=max(weight_list);
    elseif(cor_list(max_path)<0)  %��ýǶȵ�BSV�����
        fprintf('�״���������Ϊ��\n');
        %ת��Ϊ����أ���ʹBSVȡ��ֵ
        multi_path_bsv_ori=-multi_path_bsv_ori;
        multi_path_bsv_ori=multi_path_bsv_ori-min(multi_path_bsv_ori)+1000;
        weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %����0
        min_weight=0;
        max_weight=max(weight_list);
    else
        fprintf('�״���������Ϊ0\n');
    end
    
    min_percent=0.05;
    left_percent = 1;
    percent_array=left_percent;% ʣ���bsv���ź�ǿ�� ռԭ�ź�ƽ��ǿ�ȵİٷֱ�
    
    %ÿ��ѭ����ȡһ���Ƕ�
    pathN=0;
    while true
        pathN=pathN+1;
        cor_min = 1;
        good_weight=max_weight;     
        for ii = max_weight/100:max_weight/100:max_weight
            % һ�㣬һ���ȥȨ������·��
            multi_path_bsv_ori_temp = multi_path_bsv_ori - ii*(pattern_array(max_path,:));
            remain_cor=corrcoef(multi_path_bsv_ori_temp,(pattern_array(max_path,:)));
            % �ҳ�������������0�ģ�����¼�¼�ȥ����·����Ȩ��
            if abs(abs(remain_cor(1,2))-cor_min)<1e-3  %�Ƿ��ж�����ʵ�weight
                fprintf(2,'pathN=%d,weighti=%f,cor=%f\n',pathN,ii,remain_cor(1,2));
            elseif abs(remain_cor(1,2)) < cor_min
                cor_min = abs(remain_cor(1,2));
                good_weight = ii;
                %                 fprintf(2,'minus_weight:%f cor_min:%f\n',minus_weight,cor_min);
            else
                %                 fprintf('weight:%f cor_min:%f\n',ii,abs(remain_cor(1,2)));
            end
        end
        
        %ʣ��BSV����Ƕ�BSV�������
        cor_list_temp = [];
        multi_path_bsv_ori_temp=multi_path_bsv_ori - good_weight*(pattern_array(max_path,:));
        for angle_id = 1:61
            temp_cor = corrcoef(multi_path_bsv_ori_temp,(pattern_array(angle_id,:)));
            cor_list_temp = [cor_list_temp temp_cor(1,2)];
        end
        cor_list_new = cor_list_temp;
        [sort_cor,id]=sort(abs(cor_list_new),'descend');  %������ֵ����
        
        % ��ȥ��һ����·����Ȩ�أ����µ�·���Ƕ�
        multi_path_bsv_ori = multi_path_bsv_ori - good_weight*(pattern_array(max_path,:));
        left_percent = mean(multi_path_bsv_ori)/mean(multi_path_bsv_ori1);  %ʣ���ռԭʼ�ı���
        percent_array=[percent_array left_percent];
        if useGroup
            [max_v,max_path]=decidePath(cor_list_new,max_cor_num);
        else
            [max_v,max_path] = max(abs(cor_list_new));
        end
        max_cor=[max_cor max_v];
        % sum(abs(cor_list_new))
        if(max_v>sum(abs(cor_list_new))/pathCoe)  %ʣ���BSV����Ƕ�BSV�Ƿ����㹻�����
            pre_angle_list = [pre_angle_list (max_path-1)*3];  %·����Ӧ�ĽǶ�
            pre_path=[pre_path max_path];  %·����Ӧ��·��id
        else
            break;
        end
        
        %�µĽǶ����㹻�������������ȷ��weight��Χ
        if(cor_list_new(max_path)>0)  %��ýǶȵ�BSV�����
            if(min(multi_path_bsv_ori)<0)
                multi_path_bsv_ori=multi_path_bsv_ori-min(multi_path_bsv_ori)+1000;
                fprintf('path%d��СBSVΪ��\n',pathN+1);
            end
            weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %����0
            min_weight=0;
            max_weight=max(weight_list);
        elseif(cor_list_new(max_path)<0)
            fprintf('path%d��������Ϊ��\n',pathN+1);
            %ת��Ϊ����أ���ʹBSVȡ��ֵ
            multi_path_bsv_ori=-multi_path_bsv_ori;
            multi_path_bsv_ori=multi_path_bsv_ori-min(multi_path_bsv_ori)+1000;
            weight_list=multi_path_bsv_ori./pattern_array(max_path,:);  %����0
            min_weight=0;
            max_weight=max(weight_list);
        else
            fprintf('��������Ϊ0\n');
        end
    end
    
%     esti_angle_array{xx} =pre_angle_list;
    simuAoA = unique(pre_angle_list);
end

