function vizIntensityBased(inX_,names,NumCluster)
% NumCluster =8;
% Z = linkage(Y);
numfiles = size(inX_,2);
Z = linkage(inX_','ward','cosine');
% clust = cluster(Z, 'maxclust', NumCluster); 
color = Z(end-NumCluster+2,3)-eps;

%
% tree = linkage(X,'average');
% close all
figure
H = dendrogram(Z,numfiles,'ColorThreshold',color,'labels',names);
% H = dendrogram(Z,numfiles,'ColorThreshold',color,'labels',names);
set(gca,'xticklabelrotation',-45)
% set(gca,'Interpreter','latex');
