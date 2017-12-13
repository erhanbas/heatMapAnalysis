%% parameters.
parentFolder = 'Z:\Analysis\Cortico-Thalamic\Run 1 all';
mainFolder = fullfile(parentFolder,'Cluster Results');
outputFolder = fullfile(parentFolder,'Max Projections Individual Groups');
anaMasks = {'thalamus','isocortex','thalamus_isocortex'};
contourFiles = {'thalamus','root'};
contourBin = 20;
contourFolder = 'Z:\Manuscript\biorxiv\Figures\Consensus\outlineMasks\';
%% Projection settings.
axisNames = {'Left-right axis','Dorsoventral axis','Anteroposterior axis'};

disp.coronal.dimSelection = [1,2];
disp.coronal.xLim =         [0,11000];
disp.coronal.yLim =         [0,9000];
% disp.coronal.sliceRange =   [6000,7000];
disp.coronal.sliceRange =   [1000,12000];
disp.coronal.subPlot = 1;

disp.saggital.dimSelection = [3,2];
disp.saggital.xLim =         [0,14000];
disp.saggital.yLim =         [0,8000];
% disp.saggital.sliceRange =   [3900,4400];
disp.saggital.sliceRange =   [2000,10000];
disp.saggital.subPlot = 3;

disp.horizontal.dimSelection = [1,3];
disp.horizontal.xLim =         [0,11000];
disp.horizontal.yLim =         [0,9000];
% disp.horizontal.sliceRange =   [1000,7000];
disp.horizontal.sliceRange =   [1000,8000];
disp.horizontal.subPlot = [2,4];

%% general parameters.
databaseFolder = 'Z:\registration\Database';
contourFile = 'Z:\Manuscript\biorxiv\Figures\Consensus\outlineMasks\root_20.mat';
allenFile = 'Z:\registration\Allen Atlas\AllenAtlas8bit.nrrd';

%% load cluster results.
for iMask = anaMasks
    %% Load results.
    mask= iMask{:};
    if ~isdir(fullfile(outputFolder,mask)), mkdir(fullfile(outputFolder,mask)); end
    fprintf('\nMask: %s',mask);
    load(fullfile(mainFolder,sprintf('Clustering Result %s.mat',mask)));
    if ~isdir(fullfile(outputFolder,mask)),mkdir(fullfile(outputFolder,mask)); end
    for iGroup = 1:size(result.groupColor,1)
            hFig = figure('Color',[0,0,0]);
            set(hFig, 'Position', get(0, 'Screensize'));
            fprintf('\nGroup %i\\%i',iGroup,size(result.groupColor,1));
            neurons = result.cells(result.cellGroup == iGroup);
            neuronInfo = {}; 
            cMap = jet(size(neurons,2));
            for iNeuron = 1:size(neurons,2)
                fprintf('\nLoading Neuron Info %s',neurons{iNeuron});
                neuronInfo = [neuronInfo; getNeuronfromIdString(neurons{iNeuron},'ForceHemi','right')];
            end

        %% Plot per projection.
        for iProj = {'coronal','saggital','horizontal'}

            %% Setup figure.
            hAx = subplot(2,2,disp.(iProj{:}).subPlot);
            hAx.Color = [0,0,0];
            hAx.XColor = [1,1,1];
            hAx.YColor = [1,1,1];
            hAx.ZColor = [1,1,1];
            hAx.TickDir = 'out';
            hAx.YDir = 'reverse';
            hAx.FontName = 'Arial';
%             hAx.XLim = disp.(iProj{:}).xLim;
%             hAx.YLim = disp.(iProj{:}).yLim;
            hAx.DataAspectRatio = [1,1,1];
            xlabel(axisNames{disp.(iProj{:}).dimSelection(1)});
            ylabel(axisNames{disp.(iProj{:}).dimSelection(2)});
            hold on

            %% Plot neurons.
            labels = {};
            for iNeuron = 1:size(neurons,2)
                cNeuron = neuronInfo{iNeuron};
                swc = [[cNeuron.axon.sampleNumber]',[cNeuron.axon.structureIdValue]',...
                    [cNeuron.axon.x]',[cNeuron.axon.y]',[cNeuron.axon.z]',...
                    ones(size(cNeuron.axon,1),1),[cNeuron.axon.parentNumber]'];
                hNeuron = plotSwcFast2D(swc,disp.(iProj{:}).dimSelection);
                hNeuron.Color = cMap(iNeuron,:);
                hNeuron.LineWidth = 1.5;
                labels = [labels; sprintf('\\color[rgb]{%.3f,%.3f,%.3f}%s',cMap(iNeuron,1),cMap(iNeuron,2),cMap(iNeuron,3),neurons{iNeuron})];
            end
            %% Legend.
            hLegend = legend(labels);
            hLegend.Color = [0,0,0];
            hLegend.AutoUpdate = 'off';
            
            sliceDim = find(~ismember([1,2,3],disp.(iProj{:}).dimSelection));
            %% Plot allen outlines.
            for contour=contourFiles        
                contourFile = fullfile(contourFolder,sprintf('%s_%i.mat',contour{:},contourBin));
                sliceDim = find(~ismember([1,2,3],disp.(iProj{:}).dimSelection));
                try
                    [ x, y, color] = getRegionMaskOutline( contourFile, disp.(iProj{:}).dimSelection, disp.(iProj{:}).sliceRange );
                    if strcmpi(contour{:},'root'), color = [1,1,1]; end
                    for iComp = 1:size(x,1)
                        hOutline = plot(x{iComp}(1:10:end),y{iComp}(1:10:end),'Color',color,'LineStyle','--','LineWidth',2);
                    end
                catch ME
                   warning(ME.message);
                end
            end
            
        end
        hAx.YDir = 'normal';
        hTitle = suptitle(sprintf('%s - Group %i',mask,iGroup));
        hTitle.Color = [1,1,1];
        export_fig(hFig,fullfile(outputFolder,mask,sprintf('%s_Group_%i.png',mask,iGroup)),'-m2','-a4','-nocrop');
    end
    
end