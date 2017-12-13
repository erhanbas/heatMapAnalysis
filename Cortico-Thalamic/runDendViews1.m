parentFolder = 'Z:\Analysis\Cortico-Thalamic\Run 1 all';
mainFolder = fullfile(parentFolder,'Cluster Results');
outputFolder = fullfile(parentFolder, 'Dendrite views groups');
anaMasks = {'thalamus','isocortex','thalamus_isocortex'};

%% load cluster results.
for iMask = anaMasks
    %% Load results.
    mask= iMask{:};
    if ~isdir(fullfile(outputFolder,mask)), mkdir(fullfile(outputFolder,mask)); end
    fprintf('\nMask: %s',mask);
    load(fullfile(mainFolder,sprintf('Clustering Result %s.mat',mask)));
    
    nGroups = size(result.groupColor,1);
    for iGroup = 1:nGroups
        rotations = regexp([result.cellInfo(result.cellGroup==iGroup).Rotations],'[+-]?\d*','match');
        rotations = reshape(rotations,3,[])';
        rotations = str2double(rotations);
        % generate dendrite view.
        hFigStore = genDendriteView( result.cells(result.cellGroup==iGroup),...
            [result.cellInfo(result.cellGroup==iGroup).Depth],...
            'YLim',[-1350,400],...
            'RotationAngles', rotations,...
            'LineProperties',{'Color',result.groupColor(iGroup,:)});
        % Export .
        for iFig = 1:size(hFigStore,1)
            export_fig(hFigStore(iFig),fullfile(outputFolder,mask,sprintf('Cluster_%s_Group_%i - %i.png',mask,iGroup,iFig)),'-m2','-a4','-nocrop');
        end
    end
end