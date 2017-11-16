function [H,P] = vizClust(hZ,hcolor,names,tag)
addpath(genpath('./export_fig'))
% close all
numfiles = length(names);
figure('units','normalized','outerposition',[0.5 0 .5 1])
set(gcf,'Color','k');
[H,~,P] = dendrogram(hZ,numfiles,'ColorThreshold',hcolor,'labels',names);
set(gca,'xticklabelrotation',90);
set(gca,'Color','k');
set(findobj('Type','Line','Color','k'),'Color','w')
set(gca, 'YColor', [1 1 1]*.7);
set(gca, 'XColor', [1 1 1]*.7);

if ~isempty(tag)
    tag1 = tag{1};
    tag2 = tag{2};
    ix1 = find(contains(names,tag1));
    ix2 = find(contains(names,tag2));
    [Index1,Index2] = tagIds(tag1,tag2);
end
