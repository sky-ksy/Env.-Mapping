function plotHirTree(figId,tree,leafNum)
%ªÊ÷∆æ€¿‡ ˜
f=figure(figId); clf(f);
[h,nodes] = dendrogram(tree,leafNum);
h_gca = gca;
h_gca.TickDir = 'out';
h_gca.TickLength = [.002 0];
h_gca.XTickLabel = [];