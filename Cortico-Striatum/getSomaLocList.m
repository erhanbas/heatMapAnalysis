%% File Parameters.
mainFolder = 'Z:\Analysis\Cortico-Striatum';
inputFile = fullfile(mainFolder,'CellList.xlsx');
[num,cellList,raw] = xlsread(inputFile);
cellList = cellList';
somaLoc = [];
for iCell = 1:size(cellList,2)
    fprintf('\n%s [%i\\%i]',cellList{iCell},iCell,size(cellList,2));
    neuron = getNeuronfromIdString(cellList{iCell});
    somaLoc = [somaLoc; neuron.axon(1).x,neuron.axon(1).y, neuron.axon(1).z];
end
