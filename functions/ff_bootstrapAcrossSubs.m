function [ci, meanSlope, slopes] = ff_bootstrapAcrossSubs(subjectCellPairwise, plotOnCurFig, maxValue)
% [ci, bootstat, slopes] = ff_bootstrapAcrossSubs(subjectCellPairwise, plotOnCurFig, maxValue)
%
% Bootstrapped mean across subjects given subject pairwise data 
%
% INPUTS
% subjectCellPairwise:      a cell of size numSubs x 2
%       the first and second column is the x and y data respectively
% plotOnCurFig:             whether or not to plot on the current fig
%                           assumes the curFig is (3D) 
% maxValue:                 axis max (bootstrap plotting purposes)
%
% OUTPUTS
% ci:                       [ciLower, ciUpper] of 1000 bootstrapped samples across subjects
% meanSlope:                the mean of the 1000 bootstrapped samples

%% initialize
numSubs = size(subjectCellPairwise,1); 
slopes = zeros(numSubs,1);
slopesCI_indvidual = zeros(numSubs,2);

%% fit a line to individual subjects
for ii = 1:numSubs
    
    x1 = subjectCellPairwise{ii,1};
    x2 = subjectCellPairwise{ii,2};
    [b, bint] = regress(x2', x1'); 
    slopes(ii) = b; 
    slopesCI_indvidual(ii,:) = bint; 
    
end

%% bootstrapping acorss subjects

% only bootstrap if we have more than one subjects
% otherwise return 
if numSubs == 1
    ci = slopesCI_individual; 
else
    numbs = 1000; 
    [ci, bootstat] = bootci(numbs, @mean, slopes);    
end
meanSlope = mean(bootstat);

%% plotting
if plotOnCurFig
    
    npoints = 100; 
    maxZ = max(get(gca, 'ZLim'));
    zVec = maxZ*ones(1, npoints); 
    
    bx = linspace(0, maxValue, npoints);
    by = bx * meanSlope; 
    bylower = bx * ci(1); 
    byupper = bx * ci(2);
        
    plot3(bx, by, zVec, '-', 'Linewidth',3, 'color', [0 1 1])
    plot3(bx, bylower, zVec, '-', 'Linewidth',.1, 'color', [0 .7 .7])
    plot3(bx, byupper, zVec, '-', 'Linewidth',.1, 'color', [0 .7 .7])
    
end

end
