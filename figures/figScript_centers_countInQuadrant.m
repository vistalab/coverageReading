%% count the number of pRF centers in each quadrant
% how we divide up the quadrant can be specified

close all; clear all; clc;
bookKeeping; 

%% modify here

% ASSUMPTIONS for now: 
% - make a group calculation - combine over all subjects - as opposed to
% caluclating for each individual listed
% - one roi, one ret model

list_subInds = 1:20;

roiName = {'combined_VWFA_rl'};
dtName = {'Words'};
rmName = {'retModel-Words-css.mat'};

vfc = ff_vfcDefault(); 
vfc.addCenters = true; 

% quadrant definition 
% 1: the axes are the cardinal directions
% 2: the axes are the diagonals
quadOption = 2; 

%% make the rmroiCell
rmroiCell = ff_rmroiCell(list_subInds, roiName, dtName, rmName);

%% define some things / initialize
numSubs = size(rmroiCell,1);
Polar = [];

% counts
quadCount = zeros(1,4);

% the range the polar angle has to be in to belong in a give quadrant
quadLimits = cell(4,1);
if quadOption == 1
    quadLimits{1} = [0 pi/2];
    quadLimits{2} = [pi/2 pi];
    quadLimits{3} = [pi pi*3/2];
    quadLimits{4} = [pi*3/2 2*pi];
elseif quadOption == 2
    quadLimits{1} = [0 pi/2] - pi/4;
    quadLimits{2} = [pi/2 pi] - pi/4;
    quadLimits{3} = [pi pi*3/2] - pi/4;
    quadLimits{4} = [pi*3/2 2*pi] - pi/4;
end

%% make the group average coverage plot with centers
rfMean = ff_rmPlotCoverageGroup(rmroiCell, vfc, 'flip', false);

%% pool the theta info
for ii = 1:numSubs
    
    Polar = [Polar rmroiCell{ii}.polar];
    
end

%% calculate the percentage of centers in each quadrant
for qq = 1:4
   
    quadMin = quadLimits{qq}(1);
    quadMax = quadLimits{qq}(2);
    
    % centers that land within the quadrant
    sumWithin = sum( ((Polar < quadMax) & (Polar > quadMin)));
    
    % centers that lie on the lower boundary of the quadrant
    % edge case literally
    sumBound = sum(Polar == quadMin);
    
    % centers of the quadrant
    sumQuad = sumWithin + sumBound; 
    
    quadCount(qq) = sumQuad; 
    
end

 quadCountProportion = quadCount / sum(quadCount)


%% save
titleName = {
    ['Center proportion. ' ff_stringRemove(roiName{1}, '_rl')]
    ['QuadOption: ' num2str(quadOption)]
    ['QuadProption: ' num2str(quadCountProportion)]
    };

title(titleName, 'fontWeight', 'bold');

ff_dropboxSave;