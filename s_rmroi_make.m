%% makes a temporary rmroi struct - RMROI
% sometimes we just have preliminary data from 1 or 2 subjects, 
% so making the rmroi struct for only a couple of subjects might introduce 
% later book-keeping headaches in terms of naming conventions, who is
% included, etc

clear all; close all; clc;
chdir('/biac4/wandell/data/reading_prf/coverageReading')
bookKeeping; 

%% modify here

% list of subjects 
list_subInds = [1 4];

% the list of sessions as indicated in bookKeeping. a string
theListStr = 'list_sessionRetFaceWord'; 

% rois we are interested in
list_rois = {
    'CV1_rl';
    'ch_FFA_Face_rl';
    'ch_VWFA_rl';
    };

% rms we're interested in
list_rms = {
    'FaceLarge';
    'FaceSmall';
    'WordLarge';
    'WordSmall';
    };


%% define things

% list of the session paths
theList = eval(theListStr);

% number of subjects
numSubs = length(list_subInds);

% number of rois
numRois = length(list_rois);

% number of rms
numRms = length(list_rms);

% initialize
RMROI = cell(numSubs, numRois, numRms);

%% do things


    
for ii = 1:numSubs

    % subject index and subject vista directory
    subInd = list_subInds(ii);
    vistaDir = theList{subInd}; 
    
    % go to subject's directory and initialize gray view
    chdir(vistaDir);
    vw = initHiddenGray; 
    
    for kk = 1:numRms
        
        % this rm, and its path
        rmName = list_rms{kk};
        rmPath = fullfile(vistaDir, 'Gray', rmName, ['retModel-' rmName '.mat']);
        
        % load the rm model
        vw = rmSelect(vw, 1, rmPath);
        vw = rmLoadDefault(vw);
        
        for jj = 1:numRois
           
            % this roi and its path
            roiName = list_rois{jj};
            roiPath = fullfile(list_anatomy{subInd}, 'ROIs', roiName); 
            
            % load the roi
            % [vw, ok] = loadROI(vw, filename, select, clr, absPathFlag, local)
            vw = loadROI(vw, roiPath, 1, [], 1, 0); 
            
            % get the rmroi struct and store it
            rmroi = rmGetParamsFromROI(vw); 
            RMROI{ii,jj,kk} = rmroi; 
               
        end   
    end
end



%% plot things
close all; 

