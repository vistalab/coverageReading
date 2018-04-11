function varExp = ff_varExp(ts1, ts2)
% Calcuate the variance explained 
% Using this formula:
%
% rawrss = sqrt(sum(vec2.^2))
% rss =  sqrt(sum((vec1 - vec2).^2))
% 1 - rss / rawrss; 
%
% Which is based off of this formula:
% val = 1 - (model.rss ./ model.rawrss);
% val(~isfinite(val)) = 0;
% val = max(val, 0);
% val = min(val, 1);


%% calculating
% rawrss is the time series
% rss is the difference between the prediction and the time series
%
rawrss = (sum(ts1.^2));
rss =  (sum((ts2 - ts1).^2));
varExp = 1 - rss ./ rawrss; 
varExp(~isfinite(varExp)) = 0; 
varExp = max(varExp,0); 
varExp = min(varExp,1);

% this also works %% try matab functions
% rawrss = rssq(ts1,1).^2; 
% rss = rssq((ts2-ts1), 1).^2;
% varExp = 1 - rss ./ rawrss; 
% varExp(~isfinite(varExp)) = 0; 
% varExp = max(varExp,0); 
% varExp = min(varExp,1);

end



