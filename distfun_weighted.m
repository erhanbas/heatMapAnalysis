function e = distfun_weighted(XX)

numfiles=size(XX,3);
inds2process = find(triu(ones(numfiles),1));
d1 = zeros(1,length(inds2process));
d2 = zeros(1,length(inds2process));

%%
for kk=1:length(inds2process)
    [jj,ii] = ind2sub([numfiles numfiles],inds2process(kk));
    XXj = XX(:,:,jj);
    XXj = XXj(all(XXj,2),:);
    wj = XXj(:,1);
    wj = wj/max(wj);
    xj = XXj(:,2:end);
    
    XXi = XX(:,:,ii);
    XXi = XXi(all(XXi,2),:);
    wi = XXi(:,1);
    wi = wi/max(wi);
    xi = XXi(:,2:end);

    wD = pdist2(wi,wj);
    xD = pdist2(xi,xj);
    % for each index find the closest
    [minvals,minidx] = min(xD,[],2);
    p1 = mean(wD(sub2ind(size(wD),[1:size(wD,1)]',minidx(:))));
    [minvals,minidx] = min(xD,[],1);
    p2 = mean(wD(sub2ind(size(wD),minidx(:),[1:size(wD,2)]')));
    d1(kk) = p1;
    d2(kk) = p2;
end
e1 = zeros([numfiles,numfiles]);
e1(inds2process) = d1;
e1 = max(e1,e1');
e2 = zeros([numfiles,numfiles]);
e2(inds2process) = d2;
e2 = max(e2,e2');
e=cat(3,e1,e2);


% %%
% d = zeros(numfiles,numfiles,2);
% 
% for jj=1:numfiles
%     XXj = XX(:,:,jj);
%     XXj = XXj(all(XXj,2),:);
%     wj = XXj(:,1);
%     wj = wj/max(wj);
%     xj = XXj(:,2:end);
%     for ii=jj+1:numfiles
%         XXi = XX(:,:,ii);
%         XXi = XXi(all(XXi,2),:);
%         wi = XXi(:,1);
%         wi = wi/max(wi);
%         xi = XXi(:,2:end);
%         
%         wD = pdist2(wi,wj);
%         xD = pdist2(xi,xj);
%         % for each index find the closest
%         [minvals,minidx] = min(xD,[],2);
%         p1 = mean(wD(sub2ind(size(wD),[1:size(wD,1)]',minidx(:))));
%         [minvals,minidx] = min(xD,[],1);
%         p2 = mean(wD(sub2ind(size(wD),minidx(:),[1:size(wD,2)]')));
%         d(jj,ii,1) = p1;
%         d(jj,ii,2) = p2;
% 
%     end
% end
% % d(:,:,1) = max(d(:,:,1),d(:,:,1)');
% % d(:,:,2) = max(d(:,:,2),d(:,:,2)');
