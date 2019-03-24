function plotEstiResult(param,aviApId,ap)

env_param=param.env_param;
sys_param=param.sys_param;
virRF=param.virRF;
virSrc=param.virSrc(aviApId);
plotSysSetup(env_param, sys_param, virRF, virSrc);
hold on;
p=plot(ap(:,1),ap(:,2),'dk','MarkerSize',8,'LineWidth',1.5);
hold off;
legend(p,'����AP');
title(['��',num2str(param.TxP),'��Txλ��']);
% saveas(gcf,['./groupMedianAP/Tx',num2str(param.TxP),'.jpg']);
