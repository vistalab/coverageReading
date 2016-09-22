function [fh, R] = plotHistRrmse(info)
% Make a plot of the RMSE Ratio:

R       = info.rrmse;
figName = sprintf('%s - RMSE RATIO',info.tractography);
fh      = mrvNewGraphWin(figName);
[y,x]   = hist(R,linspace(.5,4,50));
plot(x,y,'k-','linewidth',2);
hold on
plot([median(R) median(R)],[0 1200],'r-','linewidth',2);
plot([1 1],[0 1200],'k-');
set(gca,'tickdir','out','fontsize',16,'box','off');
title('Root-mean squared error ratio','fontsize',16);
ylabel('number of voxels','fontsize',16);
xlabel('R_{rmse}','fontsize',16);
legend({sprintf('Distribution of R_{rmse}'),sprintf('Median R_{rmse}')});
end