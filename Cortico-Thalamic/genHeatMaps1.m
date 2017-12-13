%% File Parameters.
mainFolder = 'Z:\Analysis\Cortico-Thalamic\Run 1 all';
outputFolder = fullfile(mainFolder, 'HeatMaps');
anaList = {{'thalamus'},{'isocortex'},{'thalamus','isocortex'}};
%% Read excel info sheet
inputFile = fullfile(mainFolder,'CellList.xlsx');
[num,cellList,raw] = xlsread(inputFile);

%% Call main function.
genHeatMaps(cellList,anaList,outputFolder,...
    'VoxelSize',[150,150,150],...
    'VoxelDilation',0,...
    'StructureFilter',[0,1,5,6],... % swc format
    'ForceHemi','right');
