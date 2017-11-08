function Y = pdArr(XX)
numfiles=size(XX,3);
Y = zeros(numfiles,numfiles);
for jj=1:numfiles
    for ii=jj+1:numfiles
        diffs = XX(:,:,jj)-XX(:,:,ii);
        Y(ii,jj) = norm(diffs);
    end
end
