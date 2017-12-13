function [pDupdated,hpD,P,names,namesC] = createPlots(inputfold,experiment,vizfolder,hcolorin)

if nargin>3 & ~exist(vizfolder,'dir')
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

%%

[h_data,hxyz_data,nhxyz_data] = prepareData(data);

% pair distance based on mindistace-match-heatmap
dminmax = distfun_weighted(hxyz_data);
dm = max(dminmax(:,:,1),dminmax(:,:,2));
dm = max(dm,dm');

%%
% close all
for type = {'jaccard'} % hist
    %%
    % tag =  {'n0059','n0265'};
    tag = [];
    [hpD,hZ,hcolor,NumCluster]=dendClust(h_data,type{1});
    if NumCluster==1 %based on cc
        [H,P] = vizClust(hZ,hcolor+sqrt(eps),names,tag);
    else
        vizClust(hZ,hcolor,names,tag);
    end
    
    if exist('hcolorin','var')
        hcolor = hcolorin;
        NumCluster = sum(hZ(:,3)>=hcolor)+1;
    else
        hcolor = hcolorin;
    end
    
    if NumCluster==1 %based on cc
        [pDupdated] = hpD;
    else
        % since tree there are #edge+1 clusters
        pDupdated = pDCorrection(dm,hpD,hZ,NumCluster);
        [upZ,upcolor] = d2Z(pDupdated);
        upcolor = hcolor;%1+sqrt(eps); % to preserve initial clustering result, set threshold to 1
        [H,P] = vizClust(upZ,upcolor,names,tag);
    end
    ax = gca; % get the axes handle
    ticklabels = names(P);
    labelcolor = recolortext(H,ax,ticklabels);
    namesC=labelcolor;namesC(P,:)=labelcolor;
    title(sprintf('%s-clust',type{1}))
    if exist('vizfolder','var') & ~isempty(vizfolder)
        export_fig(fullfile(vizfolder,sprintf('%s-%s-clust.tif',experiment,type{1})))
    end
    
end