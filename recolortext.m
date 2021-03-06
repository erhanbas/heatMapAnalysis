function labelcolor = recolortext(H,ax,ticklabels)
%%
ticklabels_new = ticklabels;
X = reshape([H(:).XData]',4,[])';
Y = reshape([H(:).YData]',4,[])';
lab = ax.XAxis.TickLabels; % get all the labels
ax.XAxis.TickLabelInterpreter = 'tex';
labelcolor = zeros(length(ticklabels),3);
% for every tick get the label
for kk=1:length(ticklabels)
    namekk = ticklabels{kk};
    % find in H with that index
    idxH = find((X(:,1)==kk & Y(:,1)==0)|(X(:,4)==kk & Y(:,4)==0));
    % color of line
    col_kk = H(idxH).Color;
    % set(H(idxH),'Color',[1 1 0])
    %%
    % rename text with the color
    ax.XAxis.TickLabelInterpreter = 'tex';
    ticklabels_new{kk} = sprintf('\\color[rgb]{%f, %f, %f}%s', col_kk, namekk);
    labelcolor(kk,:) = col_kk;
end
% set the tick labels
set(gca, 'XTickLabel', ticklabels_new);
