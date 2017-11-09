%% File Parameters.
mainFolder = 'Z:\Analysis\Cortico-Striatum';
outputFolder = fullfile(mainFolder, 'FlatMaps 2017-11-07');

%% Read excel info sheet
inputFile = fullfile(mainFolder,'CellList.xlsx');
[num,cellList,raw] = xlsread(inputFile);
cellList = cellList';

%% Call main function.
h=figure;
for iCell = 1:size(cellList,2)
   for type={'axon','dendrite'}
       [pntData,hFig]=mapNeuron(cellList{iCell},'Type',type{:},'Color','depth','HFig',h);
       hFig.Color = [1,1,1];
       hFig.Position = [0,0,800,600];
       drawnow;
       export_fig(hFig, fullfile(outputFolder,sprintf('%s_%s_flatMap.png',cellList{iCell},type{:})),'-m3');
       save(fullfile(outputFolder,sprintf('%s_%s.mat',cellList{iCell},type{:})),'pntData');
   end
end
