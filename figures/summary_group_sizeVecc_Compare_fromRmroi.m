%% code to make bootstrpapped size vs eccentricity from rmroi struct
% COMPARE THE 2 SIZES VS ECCENTRICITIES
clear all; close all; clc;
bookKeeping; 

%% modify here

% names of the rmroi structs
nameRmroi_x = 'left_VWFA_rl-Checkers-css.mat';
nameRmroi_y = 'left_VWFA_rl-Words-css.mat';

% how to threshold
h.threshecc = [0 15];
h.threshco = 0.2; 
h.threshsigma = [0 15];
h.minvoxelcount = 3; 

% rmroi dir
rmroiDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

% where to save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/sizeVecc';

%% define things

% total number of subjects
numSubs = length(list_sub); 

% paths of the rmrois
pathX = fullfile(rmroiDir, nameRmroi_x); 
pathY = fullfile(rmroiDir, nameRmroi_y); 

%% load the rmroi data and threshold

% load rmroi data for x and y axis
rmroixPrethresh = load(pathX); rmroixPrethresh = rmroixPrethresh.rmroi; 
rmroiyPrethresh = load(pathY); rmroiyPrethresh = rmroiyPrethresh.rmroi; 

% clear the empty arrays, minor bug
rmroixPrethresh(cellfun('isempty', rmroixPrethresh)) = []; 
rmroiyPrethresh(cellfun('isempty', rmroiyPrethresh)) = []; 

% threshold the data
rmroix = cell(size(rmroixPrethresh)); 
rmroiy = cell(size(rmroiyPrethresh));
for ii = 1:length(rmroixPrethresh)
    rmroix{ii} = ff_thresholdRMData(rmroixPrethresh{ii}, h); 
    rmroiy{ii} = ff_thresholdRMData(rmroiyPrethresh{ii}, h); 
end

%%



% loop over subjects we have collected data on
for ii = 1:numSubs
    
    % subject initials
    subInitials = list_sub{ii}; 
    
    % see if they have both rmroix and rmroiy data
    [rx, rxExists] = ff_rmroiForSubject(rmroix, subInitials); 
    [ry, ryExists] = ff_rmroiForSubject(rmroiy, subInitials); 
    
    % if  subject has both x and y data ...
    if rxExists && ryExists
       
        % slope and intercept for the 2 rmrois
        
       
        
    end
    
    
end


% get the size V ecc line for each subject


%% save
threshDir = ff_stringDirNameFromThresh(h); 
if ~exist(fullfile(saveDir, threshDir), 'dir')
    mkdir(fullfile(saveDir, threshDir))
end


