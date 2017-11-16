function [Z,color] = d2Z(pD,NumCluster)

numfiles = size(pD,1);
if nargin<2
    [aa,bb,cc]=find((1-pD)>0);
    A = sparse(aa,bb,1,numfiles,numfiles);
    A=max(A',A);
    [S,C] = graphconncomp(A);
    NumCluster=S;
end

pD_=pD(find(triu(pD,1)'));
Z = linkage(pD_','complete');
color = Z(end-NumCluster+1,3);
% color = Z(find(Z(:,3)==max(Z(:,3)),1)-NumCluster+2,3)-eps;
% Z(Z(:,3)>color,1:2)>numfiles
% NumCluster = sum(Z(:,3)>color);
