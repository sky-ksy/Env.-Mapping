% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     findVirtualSrc.m                                                    
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                                                                                                                      
%  *************************************************************************************

function [RetvirSrc, RetvirRF] = findVirtualSrc(env_param, sys_param, inVirSrc, inVirRF)

%如果大于最大递归深度，输出提示
if sys_param.rec_depth > sys_param.max_recDepth
    RetvirSrc = [];
    RetvirRF = [];
    if ~isfield(sys_param, 'findVirtualSrc_progress_enable') || ...
            sys_param.findVirtualSrc_progress_enable
        for ii = 1:sys_param.max_recDepth-1
%             fprintf('\t');
        end
%         fprintf('Reach max recursion %d, return\n', sys_param.max_recDepth);
    end
    return; %-----------------------------------------------------------这里返回了！！！
%若没有大于，每递归一次输出当前递归层数
else
    if ~isfield(sys_param, 'findVirtualSrc_progress_enable') || ...
            sys_param.findVirtualSrc_progress_enable
        for ii = 1:sys_param.rec_depth-1
%             fprintf('\t');
        end
%         fprintf('Current depth %d -- ', sys_param.rec_depth);
    end
end

src_pos = inVirSrc.pos;         %源点坐标
src_pathlen = inVirSrc.pathlen; %路径
src_refloss = inVirSrc.refloss; %反射损失

reflector_id = env_param.reflector_id;      %反射面ID
reflector_list = env_param.reflector_list;  %反射面列表

virSrc = [];
virRF = [];
idx = 0;

if reflector_id == -1
    N_ref = size(reflector_list, 1);    %得到反射面个数
    for ii = 1:N_ref                    %遍历反射面
        ref_pos = reflector_list(ii, 1:2);      %得到反射面坐标
        mirrp = mirrorPoint(src_pos, ref_pos);  %调用mirrorPoint算出相应镜面坐标
        
 % consider the situation that a reflecotr is blocked by other reflectors. 
 % In this case, we need to divide the reflector into multiple segments       
 %考虑反射面被阻挡的情况，须将该反射面分为多段
        seg_ref = getRefSeg(src_pos, reflector_list, ...    %调用getRefSeg将被阻挡的反射面分段
            reflector_list(ii, 1:2), ii, true);
        
        Nseg = size(seg_ref, 2);    %得到分段点的个数
        
        for kk = 1:Nseg-1   %遍历每段
            ret = getIntensity(inVirSrc, reflector_list, ...                %反射损失和路径长度
                (seg_ref(:,kk)+seg_ref(:,kk+1)).'/2, reflector_id, ii);
            
            idx = idx+1;
            virSrc(idx).pos = mirrp;    %指定当前段位置为镜像位置
            virSrc(idx).pathlen = 0;    %初始化当前段路径长
            virSrc(idx).refloss = ret.refloss+getRefLoss(reflector_list(ii,3)); %当前段反射损失
            virSrc(idx).depth = sys_param.rec_depth;    %当前段递归深度？
            virSrc(idx).ID = sys_param.virSrcN + idx;   %当前段ID=virSrc数量+该段id
            virSrc(idx).parentID = inVirSrc.ID;         %设置父亲ID
            virRF(idx).info = [complex(seg_ref(1,kk), seg_ref(2,kk)), ...   %反射面信息：
                            complex(seg_ref(1,kk+1), seg_ref(2,kk+1)),...
                            reflector_list(ii, 3:4)];
            virRF(idx).ref = ii;                        %设置当前virRF的ID
            virRF(idx).ID = sys_param.virSrcN + idx;
        end
    end
else
    N_ref = size(reflector_list, 1);    %得出反射面数量存入N_ref
    ref_ref = inVirRF.info;             %虚拟RF的信息存入ref_ref
    for ii = 1:N_ref            %每个反射面遍历一次
        if ii == reflector_id   %？？
            continue;
        end
        
        ref_pos = reflector_list(ii, 1:2);          %得到反射面起点终点
        seg_proj = getRefSeg(src_pos, ref_ref, ...  %调用getRefSeg，第ii个反射面作为目标反射面，相对于ref_ref分段
            reflector_list(ii,1:2), [], false);     
        
        mirrp = mirrorPoint(src_pos, ref_pos);      %调用mirrorPoint得出镜面点坐标
        
        seg_ref = getRefSeg(src_pos, reflector_list, ...       %调用getRefSeg，第ii个反射面作为目标反射面，相对于reflector_list
            reflector_list(ii, 1:2), [ii], true);              %分段，跳过第ii段
        if size(seg_proj,2)>=2  %如果根据ref_ref的分段，存在分段点
            seg_refidx = seg_ref(1, :)<=max(seg_proj(1,:))&...  %seg_proj x的最小值 <= seg_ref的x <= seg_proj x的最大值
                seg_ref(1,:)>=min(seg_proj(1,:))&...            %seg_proj y的最小值 <= seg_ref的y <= seg_proj y的最大值
                seg_ref(2,:)<=max(seg_proj(2,:))&...            %以上判断结果存入seg_refidx，全成立才为1，否则为0
                seg_ref(2,:)>=min(seg_proj(2,:));               
            seg_ref = seg_ref(:, seg_refidx);                   %取seg_ref的第1列*********？？？？？？？？？？？？？看不懂
        else    %若不存在分段点，跳过以下步骤
            continue;
        end
        
        Nseg = size(seg_ref, 2);    %seg_ref内分段点数量存入Nseg
        
        for kk = 1:Nseg-1   %遍历每个分段点
            ret = getIntensity(inVirSrc, reflector_list, ...    %算出反射强度和反射损失
                (seg_ref(:,kk)+seg_ref(:,kk+1)).'/2,...
                reflector_id, [ii, reflector_id]);
            
            idx = idx+1;
            virSrc(idx).pos = mirrp;
            virSrc(idx).pathlen = src_pathlen + getPathLen(src_pos, mirrp);
            virSrc(idx).refloss = src_refloss + ret.refloss+...
                getRefLoss(reflector_list(ii,3));
            virSrc(idx).depth = sys_param.rec_depth;
            virSrc(idx).ID = sys_param.virSrcN + idx;
            virSrc(idx).parentID = inVirSrc.ID;
            virRF(idx).info = [complex(seg_ref(1,kk), seg_ref(2,kk)), ...
                            complex(seg_ref(1,kk+1), seg_ref(2,kk+1)),...
                            reflector_list(ii, 3:4)];
            virRF(idx).ref = ii;
            virRF(idx).ID = sys_param.virSrcN + idx;
        end
    end
end

RetvirSrc = virSrc; %算出的虚拟源点存入RetvirSrc
RetvirRF = virRF;   %相应的虚拟反射面存入RetvirRF
N_vir = idx;        %idx为个数存入N_vir
sys_param.rec_depth = sys_param.rec_depth+1;    %递归层数+1
sys_param.virSrcN = sys_param.virSrcN+N_vir;    %将新的虚拟源点加入总集
if ~isfield(sys_param, 'findVirtualSrc_progress_enable') || ...
        sys_param.findVirtualSrc_progress_enable
%     fprintf('%d children\n', N_vir);
end
for ii = 1:N_vir    %递归的循环
    env_param.reflector_id = virRF(ii).ref;
    [tmpVirSrc, tmpVirRF] = findVirtualSrc(env_param, sys_param, virSrc(ii), virRF(ii));    %递归
    sys_param.virSrcN = sys_param.virSrcN+length(tmpVirSrc);
    
    RetvirSrc = [RetvirSrc, tmpVirSrc];
    RetvirRF = [RetvirRF, tmpVirRF];
end



