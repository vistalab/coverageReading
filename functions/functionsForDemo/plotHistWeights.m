function [fh, w] = plotHistWeights(info, descript)
% Make a plot of the weights:

w       = info.w;
figName = sprintf('%s - Distribution of fascicle weights',descript);
fh      = mrvNewGraphWin(figName);
[y,x]   = hist(w( w > 0 ),logspace(-5,-.3,40));
semilogx(x,y,'k-','linewidth',2)
set(gca,'tickdir','out','fontsize',16,'box','off')
title( ...
    sprintf('Number of fascicles candidate connectome: %2.0f\nNumber of fascicles in optimized connetome: %2.0f' ...
    ,length(w),sum(w > 0)),'fontsize',16)
ylabel('Number of fascicles','fontsize',16)
xlabel('Fascicle weight','fontsize',16)
end
