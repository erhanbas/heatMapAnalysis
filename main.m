clear all; close all;

% experiment = 'caudoputamen_isocortex';
% experiment = 'isocortex';
% experiment = 'caudoputamen'; 
% somafile = fullfile(pwd,'Cortico-Striatum','SomaInfo.xlsx');
% inputfold = fullfile(pwd,'Cortico-Striatum','HeatMaps',experiment);

if 1
    experiment = 'caudoputamen_isocortex';
    test = 'Cortico-Striatum'
elseif 1
    experiment = 'thalamus';
    test = 'Cortico-Thalamic'
end

somafile = fullfile(pwd,test,'SomaInfo.xlsx');
inputfold = fullfile(pwd,test,'HeatMaps',experiment);


vizfolder = fullfile(pwd,'vizfold',experiment);
hcolorin = 1-eps;
[pDupdated,hpD,P,names,col_names] = createPlots(inputfold,experiment,[],hcolorin);

[upZ,upcolor] = d2Z(pDupdated);
c = cluster(upZ,'Cutoff',1,'Criterion','distance'); % based on names
[a,b]=hist(c,unique(c));

output.pd = pDupdated;
output.names = names;
output.clust = c;
save(sprintf('output-%s',experiment),'output')

% [pDupdated,hZ] = createPlots(inputfold,somafile,experiment,vizfolder);
% [upZ,upcolor] = d2Z(hpD);
% c = cluster(upZ,'Cutoff',1-eps,'Criterion','distance'); % based on names
% [a,b]=hist(c,unique(c));

%%
[NUM,TXT,RAW]=xlsread(somafile);
clear soma
for ii=1:length(names)
    ix1 = find(contains({TXT{:,1}},names{ii}(1:4)));
    soma(ii).names=TXT{ix1,1};
    soma(ii).area=TXT{ix1,5};
    soma(ii).loc=[RAW{ix1,2:4}];
end
somalocs = reshape([soma.loc]',3,[])';
% make sure names matches with mat files
for ii=1:length(soma)
    if ~strcmp(soma(ii).names(3:end) , names{ii}(1:end-1))
        error('mismatched file')
    end
end
% MDScale
% XX = hxyz_data;
% Y = pdArr(XX);
markers = '.ox+*sdv^<>ph';
[labs,firstidx,ib] = unique(c);
labcolor = col_names(firstidx,:);

clear XX Y
dissimilarities_multi = max(pDupdated,pDupdated');
dissimilarities_single = max(hpD,hpD');

[Y,stress,disparities] = mdscale(dissimilarities_multi,2);

figure(100)
clf,cla
gscatter(somalocs(:,1),somalocs(:,2),c,labcolor,markers(1:length(labcolor)))
legend('Location','NorthEastOutside')
set(gca,'Color','k');
set(gca, 'YColor', [1 1 1]*.5);
set(gca, 'XColor', [1 1 1]*.5);

% %% tsne
% % Y = tsne(h_data','Algorithm','barneshut','NumPCAComponents',10);
% Y = tsne(reshape(h_data,[],size(h_data,2))','Algorithm','barneshut','NumPCAComponents',5,...
%     'LearnRate',2000,'Perplexity',20);
% % Y = tsne(reshape(h_data,[],size(h_data,2)),'Algorithm','barneshut','NumPCAComponents',5,...
% %     'LearnRate',2000,'Perplexity',100);
% 
% figure,
% dx = 0.002; dy = +0.01; % displacement so the text does not overlay the data points
% gscatter(Y(:,1),Y(:,2))
% text(Y(:,1)+dx, Y(:,2)+dy, names);
% 
% %% NN
% start = tic;
% clear net
% net = selforgmap([3 3]);
% net.trainParam.epochs= 300;
% vecXX = reshape(XX,[],size(XX,3));
% net = train(net,vecXX);
% sprintf('Training ends in: %d',toc(start))
% y = net(vecXX);
% classes = vec2ind(y);
% % mkdir('test')
% % save(sprintf('./test/classes3D_sub%s',test{1}),'classes','net')
% outputs = nncalc.y(net,{h_data});
% outputs = outputs{1};
% % dims = data(1).siz
% % hits = sum(outputs,2);
% % norm_hits = sqrt(hits/max(hits));
% % [~,back] = max(hits);
% % label = zeros(data(ii).siz,'uint8');
% % label(inds) = classes;
% % label(label==back) = 0;
% %%





