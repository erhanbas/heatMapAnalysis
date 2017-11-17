function [ result ] = runClusterHeatMap( mainFolder, anatomyMasks, cellInfo,varargin)
%runClusterHeatMap. Run clustering algorithm for supplied anatomy masks
%% Parse input.
p = inputParser;
p.addRequired('mainFolder',@(x) ischar(x));
p.addRequired('anatomyMasks',@(x) ischar(x) || iscell(x) && size(x,1)==1);
p.addRequired('cellInfo',@(x) ischar(x));
p.addParameter('CutOff',1,@(x) isnum(x));
p.parse(mainFolder, anatomyMasks, cellInfo,varargin{:});
Inputs = p.Results;
if ischar(Inputs.anatomyMasks), Inputs.anatomyMasks = {Inputs.anatomyMasks}; end

for mask = Inputs.anatomyMasks
    cMask = mask{:};
    %% Get distances
    [pDupdated,hpD,P,names,names_colors] = createPlots(mainFolder,cMask);
    %% Get clusters.
    [upZ,upcolor] = d2Z(pDupdated);
    c = cluster(upZ,'Cutoff',Inputs.CutOff,'Criterion','distance'); % based on names
    [a,b]=hist(c,unique(c));
    %% Store Results.
    result.pwd = pDupdated;
    result.names = names;
    result.clust = c;
end


end

