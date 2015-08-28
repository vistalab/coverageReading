%% CODE START %%%%%%%%%%%%%%%%%%%%%%%%%%
load('Gray/Checkers/retModel-Checkers.mat')
%%

% model solutions
m = model{1};

% stimulus radius (in degrees)
stimRadius = params.stim(1).stimSize;

% model parameters
varexp = rmGet(m, 'varexp');
gain = rmGet(m, 'amplitude comp1');
sigma = rmGet(m, 'sigma major');
ecc = rmGet(m, 'ecc');

% limit to good voxels
keepInds = (varexp > .3) & ...  ignore low variance explained
(sigma > (.1 * stimRadius)) & ...  ignore very small sigma
(ecc + 1*sigma  < stimRadius);   ... require voxels have at least +/- 1 sd inside stimulus extent


%% Look at sigma v gain
% PRFs are defined to have unit height (not unit volume). Hence volume
% scales with the square of the standard deviation*. Assuming a constant
% bold response across voxels, then the pRF amplitude should square
% inversely with the square of the standard deviation. So sigma v gain is
% linear on a log / log plot 
% gain = csigma.^2
% log(gain) = log(csigma.^2)
% log(gain) = log(c) + log(sigma.^2)
% log(gain) = C + 2log(sigma)
%
% ** An except is for pRFs which have large fractions outside the stimulus
% extent. Here our estimates of both size and gain are likely to be
% innacurate, and we should not try to account for them.

% plot sigma versus gain on linear axes
figure; 
scatter(sigma(keepInds), gain(keepInds)); 
xlabel('sigma major (deg)'); ylabel('gain')

% plot sigma versus gain on log-log axes
figure
scatter(sigma(keepInds), gain(keepInds)); 
set(gca, 'XScale', 'log', 'YScale', 'log');
xlabel('sigma major (deg)'); ylabel('gain')

% fit a line on log-log axes
p = polyfit(log(sigma(keepInds)),log(gain(keepInds)), 1);
pred = polyval(p, log(sigma(keepInds)));
hold on;
plot(sigma(keepInds), exp(pred), 'k-');
str = sprintf('log(Y) = %3.1f log(X)+%3.1f', p(1), p(2));
text(median(sigma(keepInds)), max(exp(pred)), str, 'FontSize', 20, 'Color', 'k')