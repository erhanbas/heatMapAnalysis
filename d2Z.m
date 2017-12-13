function [Z,color] = d2Z(pD,NumCluster)

numfiles = size(pD,1);
if nargin<2
    clustthr = sqrt(eps);
    [aa,bb,cc]=find((1-pD)>clustthr);
    A = sparse(aa,bb,1,numfiles,numfiles);
    A=max(A',A);
    G = graph(A);
    C = G.conncomp();
    NumCluster=max(C);
end
if size(pD,1)==size(pD,2) % square
    pD_=pD(find(triu(pD,1)'));
else
    pD_=pD;
end
Z = linkage(pD_(:)','complete');
color = Z(end-NumCluster+1,3);
