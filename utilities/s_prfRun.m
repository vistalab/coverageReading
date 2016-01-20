
%% Run PRF models
% assumes that the datatypes with the averaged tseries are already created
% and xformed
%
% rl 08/2014
clear all; close all; clc; 
bookKeeping; 

%% modify  --------------------------------------------------------------------------

% subjects we want to do this for
list_subInds = [21]; 

% session list. see bookKeeping
list_path = list_sessionRet; 

% list of checker scan number, corresponding to session list
list_numCheckers = list_scanNum_Checkers_sessionRet; 

% list of knk scan number, corresponding to session list
list_numKnk = list_scanNum_Knk_sessionRet;  

% dataTYPE name. Can run for mutiple datatypes 
list_rmName = {
    'Checkers1and2'
    }; 

% roi name. assumes in shared directory
% if we want to run on the whole brain, assign this the empty string ''
% assign this to be a string in a cell otherwise {'LV1_rl'}
% list_rois = {
%     'ch_VWFA_rl'
%     };
list_rois = ''; 

% prf model. Specify in a cell. Options: 
% {'one oval gaussian' | 'onegaussian' | 'css'}
% Note: if we want to specify multiple models, change the naming
% convention. See outFileName
prfModel = {'css'}; 

% search type. 
% 1 = grid search only ("coarse"),
% 2 = minimization search only ("fine"),
% 3 = grid followed by minimization search [default]
wSearch = 3; 

% radius of circle retinotopy in visual angle degrees
p.stimSize                  = 16; 

%% define things common to all datatypes

% name of params file
p.paramsFile_Knk            = 'Stimuli/params_knkfull_multibar_blank.mat';  % Words and FalseFont
p.paramsFile_Checkers       = 'Stimuli/params_checkers.mat';                % Checkers

% image file
p.imFile_Knk                = 'Stimuli/images_knk_fliplr.mat';              % Words and FalseFont
p.imFile_Checkers           = 'Stimuli/images_8barswithblank_fliplr.mat';   % Checkers

% params common to all dts
params.stimSize         = p.stimSize; 
params.fliprotate       = [0 0 0]; 
params.stimType         = 'StimFromScan';
params.stimWidth        = 90;               
params.stimStart        = 0;                
params.stimDir          = 0;                
params.nCycles          = 1;               
params.nStimOnOff       = 0;                
params.nUniqueRep       = 1;                
params.nDCT             = 1;     
params.hrfType          = 'two gammas (SPM style)';
params.hrfParams        = {[1.6800 3 2.0500] [5.4000 5.2000 10.8000 7.3500 0.3500]}; 
params.imfilter         = 'binary';
params.jitterFile       = 'Stimuli/none';


%% loop over all subjects
for ii = list_subInds
    
    % directory with ret vista session. move here
    dirVista = list_path{ii};
    chdir(dirVista);
    
    % open the session
    vw = initHiddenGray;

    % need some global variables later
    load mrSESSION; 

    % main anatomy path
    dirAnatomy = list_anatomy{ii};
    
    % ret parameters based on the subject
    % scan number with checkers and knk, for clip frame information
    p.scanNum_Knk                  = list_numKnk(ii);
    p.scanNum_Checkers             = list_numCheckers(ii);
    
    %% loop over the datatypes
    for kk = 1:length(list_rmName)

        % set current dataTYPE 
        rmName = list_rmName{kk};
        vw = viewSet(vw, 'curdt', rmName); 

        % get the dataType struct
        dtstruct = viewGet(vw, 'dtstruct'); 

        % get the data type number for later
        dataNum = viewGet(vw, 'curdt'); 

        % some variables depend on whether checkers or knk was run  
        if length(rmName) > 7 && strcmp(rmName(1:8), 'Checkers')
            params.paramsFile       = p.paramsFile_Checkers; 
            params.imFile           = p.imFile_Checkers; 
            p.scanNum               = p.scanNum_Checkers; 
        else
            params.paramsFile       = p.paramsFile_Knk; 
            params.imFile           = p.imFile_Knk; 
            p.scanNum               = p.scanNum_Knk; 
        end


        %% getting parameter values for prf model fit ----------------------
        params.nFrames              = viewGet(vw, 'nFrames');       
        params.framePeriod          = viewGet(vw, 'framePeriod');   
        tem.totalFrames             = mrSESSION.functionals(p.scanNum).totalFrames;  
        params.prescanDuration      = (tem.totalFrames - params.nFrames)*params.framePeriod; 

        % store it
        dataTYPES(dataNum).retinotopyModelParams = params;

        % save it
        saveSession; 

        %% Put the rm params into the view structure

        vw = rmLoadParameters(vw);  
        % the function rmLoadParameters used to call both rmDefineParameters
        % and rmMakeStimulus. If we do it here so that we can give it arguments
        % outside of the default (eg previously, sigma major and minor would be 
        % identical despite having prfModel = {'one oval gaussian'} when
        % specifying it as an argument in vw = rmMain(vw, ...)

%         scan/stim and analysis parameters
%         params = rmDefineParameters(vw, varargin)
%         params = rmDefineParameters(vw, 'model', prfModel);
% 
%         make stimulus and add it to the parameters
%          params = rmMakeStimulus(params, keepAllPoints)
%         params = rmMakeStimulus(params);

        % store params in view struct
        vw  = viewSet(vw,'rmParams',params);

        % check it 
        % rmStimulusMatrix(viewGet(vw, 'rmparams'), [],[],2,false);
        
        %% RUN THE PRF!
        %% If we've defined a list of rois to run over, do that loop here
        if ~isempty(list_rois)
            
            for jj = 1:length(list_rois)
                
                % load the current roi
                roiName = list_rois{jj};
                roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
                vw = loadROI(vw, roiPath, [], [], 1, 0);
                
                % name the ret model
                outFileName = ['retModel-' rmName '-' prfModel{1} '-' roiName];
                
                % run the model!
                vw = rmMain(vw, [], wSearch, 'model', prfModel, 'matFileName', outFileName);
                
            end
            
        else
            
            % name the ret model - whole brain
            outFileName = ['retModel-' rmName '-' prfModel{1}];
            
            % no need to load rois, just run it!
            vw = rmMain(vw, [], wSearch, 'model', prfModel, 'matFileName', outFileName);

        end
           
    end
end
