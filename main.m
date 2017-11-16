% load mat files into a cell array
clear all; close all;

experiment = 'caudoputamen_isocortex';
% experiment = 'isocortex';
% experiment = 'caudoputamen'; 
somafile = '/groups/mousebrainmicro/home/base/CODE/MATLAB/pipeline/heatMapAnalysis/Cortico-Striatum/SomaInfo.xlsx';
inputfold = fullfile('./Cortico-Striatum/HeatMaps 2017-11-7',experiment);
vizfolder = fullfile('./vizfold',experiment);

createPlots(inputfold,somafile,experiment,vizfolder);

%% MDScale
% XX = hxyz_data;
% Y = pdArr(XX);
markers = '.ox+*sdv^<>ph';
[labs,firstidx] = unique(c,'stable');
labcolor = namesC(firstidx,:);

clear XX Y
dissimilarities_multi = max(pDupdated,pDupdated');
dissimilarities_single = squareform(hpD_);

[Y,stress,disparities] = mdscale(dissimilarities_multi,2);

dx = 0.002; dy = +0.01; % displacement so the text does not overlay the data points
gscatter(Y(:,1),Y(:,2))
text(Y(:,1)+dx, Y(:,2)+dy, names);
set(gca,'Color','k')

%%
figure(100)
clf,cla
gscatter(somalocs(:,1),somalocs(:,2),c,labcolor,markers(1:length(labcolor)))
legend('Location','NorthEastOutside')
set(gca,'Color','k');
set(gca, 'YColor', [1 1 1]*.5);
set(gca, 'XColor', [1 1 1]*.5);
% text(somalocs(:,1)+dx, somalocs(:,2)+dy, names);
% text(Y(:,1)+dx, Y(:,2)+dy, somanames);

%% tsne
% Y = tsne(h_data','Algorithm','barneshut','NumPCAComponents',10);
Y = tsne(reshape(h_data,[],size(h_data,2))','Algorithm','barneshut','NumPCAComponents',5,...
    'LearnRate',2000,'Perplexity',20);
% Y = tsne(reshape(h_data,[],size(h_data,2)),'Algorithm','barneshut','NumPCAComponents',5,...
%     'LearnRate',2000,'Perplexity',100);

figure,
dx = 0.002; dy = +0.01; % displacement so the text does not overlay the data points
gscatter(Y(:,1),Y(:,2))
text(Y(:,1)+dx, Y(:,2)+dy, names);


%%





















%% NN
start = tic;
clear net
net = selforgmap([3 3]);
net.trainParam.epochs= 300;
vecXX = reshape(XX,[],size(XX,3));
net = train(net,vecXX);
sprintf('Training ends in: %d',toc(start))
y = net(vecXX);
classes = vec2ind(y);
% mkdir('test')
% save(sprintf('./test/classes3D_sub%s',test{1}),'classes','net')
outputs = nncalc.y(net,{h_data});
outputs = outputs{1};
% dims = data(1).siz
% hits = sum(outputs,2);
% norm_hits = sqrt(hits/max(hits));
% [~,back] = max(hits);
% label = zeros(data(ii).siz,'uint8');
% label(inds) = classes;
% label(label==back) = 0;
%%

% set(H,'LineWidth',2)
%%

c = cluster(Z,'maxclust',4);

names{c==4}
figure
dendrogram(Z)

%%
I = inconsistent(Z)
T = cluster(Z,'cutoff',1.2)

%%
idx = kmeans(h_data',25,'Distance','cosine')

%%
%%








