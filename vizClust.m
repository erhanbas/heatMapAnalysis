function [H,P] = vizClust(hZ,hcolor,names)
addpath(genpath('./export_fig'))
% close all
numfiles = length(names);
figure('units','normalized','outerposition',[0.5 0 .5 1])
set(gcf,'Color','k');
[H,~,P] = dendrogram(hZ,numfiles,'ColorThreshold',hcolor,'labels',names,'Orientation','right');
set(gca,'xticklabelrotation',90);
set(gca,'Color','k');
set(findobj('Type','Line','Color','k'),'Color','w')
set(gca, 'YColor', [1 1 1]*.7);
set(gca, 'XColor', [1 1 1]*.7);