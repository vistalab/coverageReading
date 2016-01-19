%% plot size vs eccentricity from rmroi struct
close all; clear all; clc; 
bookKeeping; 

%% modify here

% subjects we want to do this for. will check if this subject is in the
% rmroi
list_subInds = [1:4 6:19];

% rmroi name
list_rmroiNames = {
    'left_VWFA_rl-Checkers-css.mat'
    'left_VWFA_rl-Words-css.mat'
    'LV1_rl-Checkers-css.mat'
    'LV1_rl-Words-css.mat'
    };


% how to threshold the rm data
h.threshecc = [0 12];
h.threshsigma = [0 15];
h.minvoxelcount = 1;
h.threshco = .2; 

% where to save these graphs
% these will include a folder with thresholding
dirSave = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/sizeVecc';

% path fo the rmroi struct
rmroiDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

%% define things here

% numRmrois 
numRmrois = length(list_rmroiNames);

% number of subjects
numSubs = length(list_subInds);

%%

% loop through rmrois
for jj = 1:numRmrois
   
    % rmroiName
    rmroiName = list_rmroiNames{jj};
    rmroiPath = fullfile(rmroiDir, rmroiName); 
    
    % load. should be a variabled called rmroi
    % rmroi{ii} will give us the rmroi struct for a subject
    load(rmroiPath); 
    
    % take out the empty elements. still need to fix this minor bug
    rmroi(cellfun('isempty', rmroi)) = [];
    
    % loop over subjects 
    for ii = list_subInds
        
        % subject initials
        subInitials = list_sub{ii};
        
        %% check if subject exists in the rmroi struct
        [rm, subjectExists] = ff_rmroiForSubject(rmroi, subInitials);

        % do things if subject data exists
        if subjectExists
            
            % roi name. tech should be in the outer loop
            roinamewithext = rm.name; 
            roiName = ff_stringRemove(roinamewithext, '_rl'); 
            
            % model and stim type. 
            % we will recover this if we take out the roiName '_rl' and '.mat'
            tem = ff_stringRemove(rmroiName, roiName); 
            tem = ff_stringRemove(tem, '_rl-');
            descript = ff_stringRemove(tem, '.mat');
        
            % threshold the rmroi data
            rmThresh = ff_thresholdRMData(rm, h); 
            
            % check that voxels exist after thresholding
            if ~isempty(rmThresh)
            
                % get the size data
                siz = rmThresh.sigma;

                % get the ecc data
                ecc = rmThresh.ecc; 
                
                %% plot!
                figure; 
                plot(ecc, siz, '.')
                
                % plot properties
                axis square; 
                identityLine; 
                grid on
                
                % axes lables
                xlabel('pRF Eccentricity (degrees)')
                ylabel('pRF size (degrees)')
                
                % title
                titleName = [roiName '. ' descript '. ' subInitials '. SizeVEcc'];
                title(titleName);
                
                %% save
                
                % threshold dir name. make it if does not exist
                threshDirName = ff_stringDirNameFromThresh(h);
                chdir(dirSave);
                if ~exist(threshDirName), mkdir(threshDirName); end
                dirAfterThresh = fullfile(dirSave, threshDirName);
                
                saveas(gcf, fullfile(dirAfterThresh, [titleName '.png']), 'png')
                saveas(gcf, fullfile(dirAfterThresh, [titleName '.fig']), 'fig')
                
                
            
            end % if data remain after thresholding
            
        end % if subject Exists, do things   
    
    end % looping over specifiedd subjects
    
end % end looping over rmrois

