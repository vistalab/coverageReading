function ff_makeSubplotFromFigHandles(numRows, numCols, list_axHandles)
%% for a given list of figure handles, will make a subplot with the
% specified dimensions

% INPUTS
% numRows:        number of rows in the subplot
% numCols:        number of columns in the subplot
% list_axHandles: a vector of axes handles


%%


% total number of figures
numPlots = numRows * numCols; 

% make a new figure
figure; 

for ii = 1:numPlots
    
    % get the axes of the figures to copy into the subplot
    ah = list_axHandles(ii);
       
    % get the children of these axes
    ah_c = get(ah, 'Children')

    % create and get handles to the subplot figures
    s = subplot(numRows, numCols, ii);
    
    % copy the figure into the subplot
    copyobj(ah_c, s);
       
end






end