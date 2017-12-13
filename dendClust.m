function [pD,Z,color,NumCluster]=dendClust(inX_,type,NumCluster)
%%
% NumCluster =8;
% Z = linkage(Y);
numfiles = size(inX_,2);
% Z = linkage(inX_','complete','cosine');
% pD = squareform(pdist(inX_','cosine'));
% binMatch = pdist(inX_', @distfun);
if ndims(inX_)>2
    pD = pdArr(inX_);
else
    binMatch = pdist2(inX_',inX_', @(Xi,Xj) distfun(Xi,Xj,type) );
    pD = binMatch;
    pD = 1-pD/max(pD(:));
    pD = pD.*double(1-eye(numfiles));
end
%%
if nargin<3
    clustthr = sqrt(eps);
    [aa,bb,cc]=find((1-pD)>clustthr);
    A = sparse(aa,bb,1,numfiles,numfiles);
    A=max(A',A);
    [S,C] = graphconncomp(A);
    NumCluster=S;
end

[Z,color] = d2Z(pD,NumCluster);

%%
if 0
    [ix1,ix2]=find(min(setdiff(unique(sort(pD(:))),diag(pD)))==pD,1);
    tag1 = 'n0118'
    tag2 = 'x0283'
    ix1 = find(contains(names,tag1));
    ix2 = find(contains(names,tag2));
    
    % tag1 = names{ix1};
    % tag2 = names{ix2};
    Index1 = find(contains(xticklabels,tag1));
    Index2 = find(contains(xticklabels,tag2));
    %
    % pD(Index2,Index1)
    length(find(inX_(:,ix1)>0&inX_(:,ix2)>0))
    % get the current tick labeks
    ticklabels = get(gca,'XTickLabel');
    set(gca, 'XTickLabel', ticklabels);
    % prepend a color for each tick label
    ticklabels_new = cell(size(ticklabels));
    for i = 1:length(ticklabels)
        if any(i==[Index1,Index2])
            ticklabels_new{i} = ['\color{red} ' ticklabels{i}];
        else
            ticklabels_new{i} = ['\color{blue} ' ticklabels{i}];
        end
    end
    % set the tick labels
    set(gca, 'XTickLabel', ticklabels_new);
end
