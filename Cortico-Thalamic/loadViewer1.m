mainFolder = 'Z:\Analysis\Cortico-Thalamic\Run 1 all';
mask = 'thalamus_isocortex';
group = 2;

load(fullfile(mainFolder,'Cluster Results',sprintf('Clustering Result %s.mat',mask)));
Cells1 = result.cells(result.cellGroup==1);
color1 = brewermap(size(Cells1,2),'reds');
Cells2 = result.cells(result.cellGroup==2);
color2 = brewermap(size(Cells2,2),'blues');
reconstructionViewer([Cells1,Cells2],[color1;color2]);