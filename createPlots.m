function [pDupdated,hpD,P,names,namesC] = createPlots(inputfold,experiment,vizfolder)

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
names = cellfun(@(x) x(1:6),names,'UniformOutput',false);

%%
[h_data,hxyz_data,nhxyz_data] = prepareData(data);

% pair distance based on mindistace-match-heatmap
dminmax = distfun_weighted(hxyz_data);
dm = max(dminmax(:,:,1),dminmax(:,:,2));
dm = max(dm,dm');

%%
for type = {'jaccard'} % hist
    %%
    [hpD,hZ,hcolor]=dendClust(h_data,type{1});
    vizClust(hZ,hcolor,names);

    % since tree there are #edge+1 clusters
    NumCluster = sum(hZ(:,3)==1)+1;
    pDupdated = pDCorrection(dm,hpD,hZ,NumCluster);
    %%
    [upZ,upcolor] = d2Z(pDupdated);
    upcolor = 1; % to preserve initial clustering result, set threshold to 1
    [H,P] = vizClust(upZ,upcolor,names);
   
    ax = gca; % get the axes handle
    ticklabels = names(P);
    labelcolor = recolortext(H,ax,ticklabels);
    namesC=labelcolor;namesC(P,:)=labelcolor;
    title(sprintf('%s-clust',type{1}))
end