% this code will loop through all of the subjects and make
% rmROI structs for each roi for the control and dyslexics

close all; clear all; clc;
bookKeeping; 

%% modify here

% check bookKeeping!!!!!
% indices of the subjects we're interested in
list_subInds = [1:4 6:12]; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois/';

% names of the datatypes
list_dtNames = {
    'Checkers';
    'Words';
    'FalseFont';
    }; 

% names of the retModel in the datatypes
list_rmNames = {
    'retModel-Checkers.mat'
    'retModel-Words.mat'
    'retModel-FalseFont.mat'
    };

% name we want to give the rmroi mat file
% if we specify the empty string, the rmroi struct will just have the name
% of the roi. Otherwise, the rmroi will be saved as:
% roiName_{rmroiDescript}
rmroiDescript = '';



% rois to make this struct for
% list_roiNames = list_allRoiNames;
list_roiNames = {
    'LV2v_rl'

    'rh_ventral_BodyLimb_rl'
    'rh_lateral_BodyLimb_rl'
    'lh_ventral_BodyLimb_rl'
    'lh_lateral_BodyLimb_rl'      

%     'lh_PPA_Place_rl'
%     'rh_PPA_Place_rl'
%     'ch_PPA_Place_rl'
% 
%     'lh_OWFA_rl'
%     'rh_OWFA_rl'
%     'ch_OWFA_rl'
%     
%     'lh_WordsExceedsCheckers_rl';
%     'lh_VWFA_rl'
%     'rh_VWFA_rl'     
%     'ch_VWFA_rl'
% 
%     'lh_pFus_Face_rl'
%     'rh_pFus_Face_rl'
%     'ch_pFus_Face_rl'
%     
%     'lh_mFus_Face_rl'
%     'rh_mFus_Face_rl'
%     'ch_mFus_Face_rl'
%     
%     'lh_FFA_Face_rl'
%     'rh_FFA_Face_rl'
%     
%     'lh_FacesVentral_rl'
%     'rh_FacesVentral_rl'
%     
%     'LV1_rl'
%     'LV2d_rl'
%     'LV2v_rl'
%     'LV3d_rl'
%     'LV3v_rl'
%     'LhV4_rl'
%     'LV3ab_rl'
%     'LIPS0_rl'
%     
%     'RV1_rl'
%     'RV2d_rl'
%     'RV2v_rl'
%     'RV3d_rl'
%     'RV3v_rl'
%     'RhV4_rl'
%     'Rv3ab_rl'
%     'RIPS0_rl'
%     
%     'CV1_rl'
%     'CV2v_rl'
    };


%% define some things

% number of control and dyslexic subjects
numSubsCon = indDysStart - 1;  
numSubsDys = length(list_sessionPath) - numSubsCon; 

% number of rois
numRois = length(list_roiNames); 

% number of rms
numRms = length(list_dtNames);

% number of subjects
numSubs = length(list_subInds); 


%% loop!

for jj = 1:numRois
    
    % name of this roi
    roiName     = list_roiNames{jj};
    
    % intialize the struct
    rmroi = cell(3, numSubs); 
        
    for ii = 1:numSubs
        
        % index of this subject
        subInd = list_subInds(ii);
        
        % subject main and main ret directory
        dirVista = list_sessionPath{subInd};
        chdir(dirVista);
                 
       vw = initHiddenGray; 
        
        % subject's shared anatomy file
        d = fileparts(vANATOMYPATH); 
    
        for kk = 1:numRms

            % name of this data type
            dtName = list_dtNames{kk}; 
            
            % name of this rm model
            rmName = list_rmNames{kk};
            
            % name of the ret model. load it. 
            % vw = rmSelect(vw, loadModel, rmFile)
            vw = rmSelect(vw, 1, fullfile('Gray', dtName, rmName));
            vw = rmLoadDefault(vw);
            
            % see if the roi is drawn for this subject
            % if roi does not exist, create an empty roi struct
            if ~exist(fullfile(d, 'ROIs', [roiName '.mat']), 'file')
                rr = {}; 
            else
                % load the roi
                % [vw, ok] = loadROI(vw, filename, select, clr, absPathFlag, local)
                vw = loadROI(vw, fullfile(d, 'ROIs', roiName), [], [], 1, 0);
                
                % get the rmroi struct
                rr = rmGetParamsFromROI(vw);
                
                % flip. this is actually a mess
                rr.y0 = -rr.y0;
                
                % add initials!
                rr.subInitials = list_sub{ii};
                
            end
    
            rmroi{kk,ii} = rr; 

        end
        
        close all; 
        
    end
    
    % save it!
    % name of the rmroi struct changes depending on tseries that it was run on
    if ~isempty(rmroiDescript)
        saveName = [roiName '_' rmroiDescript];
    else
        saveName = roiName; 
    end
    
    savePath = fullfile(saveDir, [saveName '.mat']);
    save(savePath, 'rmroi')
    
    % print to screen
    display(['Finished ' roiName])
    
    
    
end
