function [Index1,Index2] = tagIds(tag1,tag2)
% tag1 = names{ix1};
% tag2 = names{ix2};
Index1 = find(contains(xticklabels,tag1));
Index2 = find(contains(xticklabels,tag2));
% get the current tick labeks
ticklabels = get(gca,'XTickLabel');
set(gca, 'XTickLabel', ticklabels);
% prepend a color for each tick label
ticklabels_new = cell(size(ticklabels));
for i = 1:length(ticklabels)
    if any(i==[Index1,Index2])
        ticklabels_new{i} = ['\color{red} ' ticklabels{i}];
    else
        ticklabels_new{i} = ['\color{blue} ' ticklabels{i}];
    end
end
% set the tick labels
set(gca, 'XTickLabel', ticklabels_new);