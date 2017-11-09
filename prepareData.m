function [h_data,hxyz_data,nhxyz_data] = prepareData(data)
numfiles = length(data);
inX = double([data.heatVec]);
dims = data(1).siz;
[aa,bb,cc] = ndgrid(1:dims(1),1:dims(2),1:dims(3));
subs = [aa(:),bb(:),cc(:)];
%%
valinds = any(inX,2);
hxyz_data = zeros([size(subs)+[0 1],numfiles]);
for ii=1:numfiles
    hxyz_data(:,1,ii) = inX(:,ii);
    hxyz_data(:,2:end,ii) = subs;
end
h_data = inX(valinds,:);
hxyz_data = hxyz_data(valinds,:,:);
XXori = hxyz_data;

%% normalize XX
nhxyz_data=XXori;
meanXX = mean(mean(nhxyz_data,1),3);
XX2 = reshape(permute(nhxyz_data,[2 1 3]),size(nhxyz_data,2),[]);
stdXX = std(XX2,[],2);
nhxyz_data = (nhxyz_data-meanXX);
nhxyz_data = nhxyz_data./stdXX';