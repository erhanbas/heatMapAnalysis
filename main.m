% load mat files into a cell array
clear all
inputfold = './CS HeatMaps';
myfiles = dir(fullfile(inputfold,'*.mat'));
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
%%
names = {data(:).name};
for ii=1:numfiles
    tmp = names{ii}(1:end-4);
    names{ii} = [tmp(end),tmp(3:6)];
end
%%
inX = double([data.heatVec]);
dims = data(1).siz;
[aa,bb,cc] = ndgrid(1:dims(1),1:dims(2),1:dims(3));
subs = [aa(:),bb(:),cc(:)];
%%
valinds = any(inX,2);
XX = zeros([size(subs)+[0 1],numfiles]);
for ii=1:numfiles
    XX(:,1,ii) = inX(:,ii);
    XX(:,2:end,ii) = subs;
end
inX_ = inX(valinds,:);
XX = XX(valinds,:,:);
XXori = XX;
%%
NumCluster=8
vizIntensityBased(inX_,names,NumCluster)
%% normalize XX
XX=XXori;
meanXX = mean(mean(XX,1),3);
XX2 = reshape(permute(XX,[2 1 3]),size(XX,2),[])';
stdXX = std(XX2);
XX = (XX-meanXX);
XX = XX./stdXX;
%% MDScale
Y = zeros(numfiles,numfiles);
for jj=1:numfiles
    for ii=jj+1:numfiles
        diffs = XX(:,:,jj)-XX(:,:,ii);
        Y(ii,jj) = norm(diffs);
    end
end
dissimilarities = max(Y,Y');
%%

%%
[Y,stress,disparities] = mdscale(dissimilarities,2);

dx = 0.2; dy = -0.2; % displacement so the text does not overlay the data points


figure, 
scatter(Y(:,1),Y(:,2))
text(Y(:,1)+dx, Y(:,2)+dy, names);

%% NN
start = tic;
clear net
net = selforgmap([3 3]);
net.trainParam.epochs= 300;
vecXX = reshape(XX,[],size(XX,3));
net = train(net,vecXX);
sprintf('Training ends in: %d',toc(start))
y = net(vecXX);
classes = vec2ind(y);
% mkdir('test')
% save(sprintf('./test/classes3D_sub%s',test{1}),'classes','net')
outputs = nncalc.y(net,{inX_});
outputs = outputs{1};
% dims = data(1).siz
% hits = sum(outputs,2);
% norm_hits = sqrt(hits/max(hits));
% [~,back] = max(hits);
% label = zeros(data(ii).siz,'uint8');
% label(inds) = classes;
% label(label==back) = 0;
%%

% set(H,'LineWidth',2)
%%

c = cluster(Z,'maxclust',4);

names{c==4}
figure
dendrogram(Z)

%%
I = inconsistent(Z)
T = cluster(Z,'cutoff',1.2)

%%
idx = kmeans(inX_',25,'Distance','cosine')

%%
%%








