% load mat files into a cell array
clear all

experiment = 'caudoputamen'
% experiment = 'caudoputamen_isocortex'
% experiment = 'isocortex'
if 0
    inputfold = './CS HeatMaps';
    somafile = 'list.xlsx'
    vizfolder = './vizfold_ori'
else
    inputfold = './Cortico-Striatum/HeatMaps 2017-11-7'
    somafile = 'SomaInfo.xlsx'
    vizfolder = './vizfold'
end


if ~exist(vizfolder,'dir')
    mkdir(vizfolder)
end

myfiles = dir(fullfile(inputfold,['*',experiment,'.mat']));
numfiles = length(myfiles);
clear data
for ii =1:numfiles
    data(ii).name = myfiles(ii).name;
    load(fullfile(inputfold,myfiles(ii).name));
    data(ii).siz = size(heatIm);
    data(ii).heatIm = heatIm;
    data(ii).heatVec = heatIm(:);
    data(ii).ontIm = ontIm;
    clear heatIm ontIm
end

names = {data(:).name};
for ii=1:numfiles
    tmp = names{ii}(1:end-4);
    names{ii} = [tmp(end),tmp(3:6)];
end

[NUM,TXT,RAW]=xlsread(fullfile(fileparts(inputfold),somafile));
clear soma
for ii=1:length(names)
    ix1 = find(contains({TXT{:,1}},names{ii}(2:end)));
    soma(ii).names=TXT{ix1,2};
    %     soma(ii).names=TXT{ix1,5};
    %     soma(ii).loc=[RAW{ix1,2:4}];
end

[h_data,hxyz_data,nhxyz_data] = prepareData(data);

% pair distance based on mindistace-match-heatmap
dminmax = distfun_weighted(hxyz_data);
dm = max(dminmax(:,:,1),dminmax(:,:,2));
dm = max(dm,dm');
%%
% NumCluster=12;
type = 'jaccard';

[hpD_,hZ,hcolor,NumCluster]=dendClust(h_data,type);
pDupdated = pDCorrection(dm,hpD_,hZ,NumCluster);
[upcolor,upZ,upNumCluster] = d2Z(pDupdated,NumCluster);

close all
figure('units','normalized','outerposition',[0 0 1 1])
H = dendrogram(hZ,numfiles,'ColorThreshold',hcolor,'labels',names);
set(gca,'xticklabelrotation',90);
set(gca,'Color','k');
set(findobj('Type','Line','Color','k'),'Color','w')
title(sprintf('%s-base',type))
export_fig(fullfile(vizfolder,sprintf('%s-%s-base.tif',experiment,type)))

figure('units','normalized','outerposition',[0 0 1 1])
H = dendrogram(upZ,numfiles,'ColorThreshold',upcolor,'labels',names);
set(gca,'xticklabelrotation',90);
set(gca,'Color','k');
set(findobj('Type','Line','Color','k'),'Color','w')
title(sprintf('%s-clust',type))
export_fig(fullfile(vizfolder,sprintf('%s-%s-clust.tif',experiment,type)))

% %% MDScale
% Y = pdArr(XX);
% dissimilarities_multi = max(Y,Y');
% dissimilarities_single = squareform(pD_);
% %%
% [Y,stress,disparities] = mdscale(dissimilarities_single,2);
% dx = 0.002; dy = -0.002; % displacement so the text does not overlay the data points
% figure,
% scatter(Y(:,1),Y(:,2))
% % text(Y(:,1)+dx, Y(:,2)+dy, names);
% text(Y(:,1)+dx, Y(:,2)+dy, somanames);
%
% %% NN
% start = tic;
% clear net
% net = selforgmap([3 3]);
% net.trainParam.epochs= 300;
% vecXX = reshape(XX,[],size(XX,3));
% net = train(net,vecXX);
% sprintf('Training ends in: %d',toc(start))
% y = net(vecXX);
% classes = vec2ind(y);
% % mkdir('test')
% % save(sprintf('./test/classes3D_sub%s',test{1}),'classes','net')
% outputs = nncalc.y(net,{h_data});
% outputs = outputs{1};
% % dims = data(1).siz
% % hits = sum(outputs,2);
% % norm_hits = sqrt(hits/max(hits));
% % [~,back] = max(hits);
% % label = zeros(data(ii).siz,'uint8');
% % label(inds) = classes;
% % label(label==back) = 0;
% %%
%
% % set(H,'LineWidth',2)
% %%
%
% c = cluster(Z,'maxclust',4);
%
% names{c==4}
% figure
% dendrogram(Z)
%
% %%
% I = inconsistent(Z)
% T = cluster(Z,'cutoff',1.2)
%
% %%
% idx = kmeans(h_data',25,'Distance','cosine')
%
% %%
% %%








