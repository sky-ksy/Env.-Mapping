% /*************************************************************************************
%                                                                                       
%    Program:       Millimeter Wave Raytracing Simulator                                
%    File Name:     plotVirSrc.m                                                        
%    Authors:       Teng Wei                                                            
%    Contact:       twei7@wisc.edu                                                      
%    Version:       1.2                                                                 
%    Date:          July 03, 2015  1:52PM                                               
%                                                                                       
%  *************************************************************************************
function plotVirSrc(sys_param, virSrc)

color = [[0 0 0];
    [1 0 1];
    [0 1 1];
    [1 0 0];
    [0 1 0];
    [0 0 1];
    [1 1 1];
    [1 1 0];];

N = length(virSrc);

hold on;

xlow = sys_param.xlow;
xhigh = sys_param.xhigh;
ylow = sys_param.ylow;
yhigh = sys_param.yhigh;

if sys_param.plotVirSrc_print
%     fprintf('ID\tpos X\tpos Y\tpathlen\trefloss\tdepth\tparentID\n');
end
for ii = 1:N
    hPoint(ii) = plot(virSrc(ii).pos(1), virSrc(ii).pos(2),'MarkerSize',15,...
        'Marker','.', 'Color', color(virSrc(ii).depth+1,:));
    if sys_param.plotVirSrc_print
%         fprintf('%.1f\t',virSrc(ii).ID, virSrc(ii).pos, virSrc(ii).pathlen, ...
%             virSrc(ii).refloss, virSrc(ii).depth, virSrc(ii).parentID);
%         fprintf('\n');
    end
    if virSrc(ii).pos(1) < xlow; xlow = virSrc(ii).pos(1)-2; end
    if virSrc(ii).pos(1) > xhigh; xhigh = virSrc(ii).pos(1)+2; end
    if virSrc(ii).pos(2) < ylow; ylow = virSrc(ii).pos(2)-2; end
    if virSrc(ii).pos(2) > yhigh; yhigh = virSrc(ii).pos(2)+2; end
end

[val, idx] = unique([virSrc.depth]);
legend(hPoint(idx), strsplit(sprintf('%d-order ', val), ' '));

axis equal
xlim([xlow xhigh]);
ylim([ylow yhigh]);

hold off