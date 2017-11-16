function createPlots(inputfold,somafile,experiment,vizfolder)

if ~exist(vizfolder,'dir')
    mkdir(vizfolder)
end
% search for '_'
tags = strsplit(experiment,'_');
tag=[];
for ii=1:length(tags)
    tag(end+1) = tags{ii}(end);
end
tag=char(tag);
%%
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

% parse file names, ugly ...
names = {data(:).name};
for ii=1:numfiles
    tmp = names{ii}(1:end-4);
    names{ii} = [tmp(3:6),tag];
end

[NUM,TXT,RAW]=xlsread(somafile);
clear soma
for ii=1:length(names)
    ix1 = find(contains({TXT{:,1}},names{ii}(1:4)));
    soma(ii).names=TXT{ix1,1};
    soma(ii).area=TXT{ix1,5};
    soma(ii).loc=[RAW{ix1,2:4}];
end
somalocs = reshape([soma.loc]',3,[])';

[h_data,hxyz_data,nhxyz_data] = prepareData(data);

% pair distance based on mindistace-match-heatmap
dminmax = distfun_weighted(hxyz_data);
dm = max(dminmax(:,:,1),dminmax(:,:,2));
dm = max(dm,dm');

%%
% close all
for type = {'jaccard'}
    %%
    % tag =  {'n0059','n0265'};
    tag = [];
    [hpD_,hZ,hcolor]=dendClust(h_data,type{1});
    vizClust(hZ,hcolor,names,tag);
    % title(sprintf('%s-base',type{1}))
    % export_fig(fullfile(vizfolder,sprintf('%s-%s-base.tif',experiment,type)))
    
    %cZ = cluster(hZ,'Cutoff',hcolor-eps,'Criterion','distance'); % based on names
    %NumCluster = max(cZ);
    
    % since tree there are #edge+1 clusters
    NumCluster = sum(hZ(:,3)==1)+1;
    pDupdated = pDCorrection(dm,hpD_,hZ,NumCluster);
    %%
    [upZ,upcolor] = d2Z(pDupdated);
    upcolor = 1; % to preserve initial clustering result, set threshold to 1
    [H,P] = vizClust(upZ,upcolor,names,tag);
    
    c = cluster(upZ,'Cutoff',upcolor,'Criterion','distance'); % based on names
    [a,b]=hist(c,unique(c));
    [a(:) b(:)];
    % names(P) := xticklabel
    % c(P) :=
    
    ax = gca; % get the axes handle
    ticklabels = names(P);
    labelcolor = recolortext(H,ax,ticklabels);
    namesC=labelcolor;namesC(P,:)=labelcolor;
    title(sprintf('%s-clust',type{1}))
    %     export_fig(fullfile(vizfolder,sprintf('%s-%s-clust.tif',experiment,type{1})))
end