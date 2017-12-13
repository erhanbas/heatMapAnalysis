parentFolder = 'Z:\Analysis\Cortico-Thalamic\Run 1 all';
mainFolder = fullfile(parentFolder,'Cluster Results');
outputFolder = fullfile(parentFolder,'Anatomy Profiles Groups');
anaMasks = {'thalamus_isocortex'};
anaProfile = {'thalamus'};

%% load cluster results.
for iMask = anaMasks
    %% Load results.
    mask= iMask{:};
    if ~isdir(fullfile(outputFolder,mask)), mkdir(fullfile(outputFolder,mask)); end
    fprintf('\nMask: %s',mask);
    load(fullfile(mainFolder,sprintf('Clustering Result %s.mat',mask)));
    
    nGroups = size(result.groupColor,1);
    for iGroup = 1:nGroups
        % run anatomy profiler.
        [ hFig, profileResult ] = genAnatomyProfile( result.cells(result.cellGroup==iGroup),anaProfile,...
            'BinSize',[100,100,100],...
            'Title',sprintf('Cluster Mask: %s, Group %i',mask,iGroup),...
            'YLims',[0,6000;0,6000;0,6000],...;
            'ErrorProperties',[{{'Color','LineWidth'}},{{result.groupColor(iGroup,:),1.5}}]);
        % Export and save.
        export_fig(hFig,fullfile(outputFolder,mask,sprintf('Cluster_%s_Region_%s_Group_%i.png',mask,anaProfile{1},iGroup)),'-m2','-a4','-nocrop');
        save(fullfile(outputFolder,mask,sprintf('Cluster_%s_Region_%s_Group_%i.mat',mask,anaProfile{1},iGroup)),'profileResult');
    end
end
