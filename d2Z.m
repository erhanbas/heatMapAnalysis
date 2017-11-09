function [color,Z,NumCluster] = d2Z(pD,NumCluster)

if nargin<2
    numfiles = size(pD,1);
    [aa,bb,cc]=find((1-pD)>0);
    A = sparse(aa,bb,1,numfiles,numfiles);
    A=max(A',A);
    [S,C] = graphconncomp(A);
    NumCluster=S;
end

pD_=pD(find(triu(pD,1)'));
Z = linkage(pD_','complete');
color = Z(end-NumCluster+1,3)-eps;
% color = Z(find(Z(:,3)==max(Z(:,3)),1)-NumCluster+2,3)-eps;
NumCluster = sum(Z(:,3)>color);
