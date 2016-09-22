function [fh, rmse, rmsexv] = plotHistRMSE(info)
% Make a plot of the RMSE:
rmse   = info.rmse;
rmsexv = info.rmsexv;

figName = sprintf('%s - RMSE',info.tractography);
fh = mrvNewGraphWin(figName);
[y,x] = hist(rmse,50);
plot(x,y,'k-');
hold on
[y,x] = hist(rmsexv,50);
plot(x,y,'r-');
set(gca,'tickdir','out','fontsize',16,'box','off');
title('Root-mean squared error distribution across voxels','fontsize',16);
ylabel('number of voxels','fontsize',16);
xlabel('rmse (scanner units)','fontsize',16);
legend({'RMSE fitted data set','RMSE cross-validated'},'fontsize',16);
end