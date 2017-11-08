function Y = pmArr(XX)
numfiles=size(XX,3);
Y = zeros(numfiles,numfiles);
for jj=1:numfiles
    for ii=jj+1:numfiles
        diffs = XX(:,:,jj)>0 & XX(:,:,ii)>0;
        Y(ii,jj) = sum(diffs(:));
    end
end