mainFolder = 'Z:\Analysis\Cortico-Thalamic\Run 1 all';
anatomyMasks = {'thalamus','isocortex','thalamus_isocortex'};
heatMapFolder = fullfile(mainFolder,'HeatMaps');
outputFolder = fullfile(mainFolder,'Cluster Results');
cellInfoFile = fullfile(mainFolder,'SomaInfo.xlsx');
runClusterHeatMap( heatMapFolder, anatomyMasks, cellInfoFile, outputFolder)