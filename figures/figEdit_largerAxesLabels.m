%% modify figures for poster purposes
% likely just use for only one occassion
% the handle to the rotated x labels is xh (a vector of length numTicks)

%% modify here
% font size
fontSize = 32;

% save directory and name
% saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';
saveDir = '~/Dropbox/TRANSFERIMAGES/';
saveName = 'sigma';

% the handle to the rotated x labels. a vector, because we used
% ff_rotateXLabels
xh

% number of tick marks
numTicks = length(xh);

for ii = 1:numTicks
    % change the font size
    set(xh(ii), 'FontSize', fontSize)
   
end

% Turn off titles
title('')
ylabel('')

% Change font size of legend and ylabel
set(gca,'FontSize', fontSize)

% save
saveas(gcf, fullfile(saveDir, [saveName '.png']), 'png')
saveas(gcf, fullfile(saveDir, [saveName '.fig']), 'fig')

