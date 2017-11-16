function pDupdated = pDCorrection(dm,pDupdated,hZ,NumCluster)
T = cluster(hZ,'MaxClust',NumCluster);
% for cluster in T, find cluster distance
NumCluster = max(T);
dClust = zeros(NumCluster);
for iclu = 1:NumCluster
    iT = find(T==iclu);
    for jclu = iclu+1:NumCluster
        jT = find(T==jclu);
        d_ = dm(iT,jT);
        dClust(iclu,jclu) = max(d_(:));
    end
end
dClust = max(dClust,dClust');

% add shifts between xterms
% pDupdated = squareform(hpD_);
numfiles = length(T);
for is = 1:numfiles
    ic = T(is);
    for js = is+1:numfiles
        jc = T(js);
        if dClust(ic,jc)
            pDupdated(is,js) = pDupdated(is,js) + dClust(ic,jc)/10;
        end
    end
end
pDupdated = max(pDupdated,pDupdated');
end