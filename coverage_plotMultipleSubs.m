%% will plot individual visual field coverage of an roi for a given list of subjects

%% modify here
clear all; close all; clc; 
bookKeeping;

% subjects we want to do this for, see bookKeeping
list_subInds = [17 14 4 1 21 11];

% the list
theList = list_sessionRet; % list_sessionPath

% roi we want the coverage of 
list_roiNames = {
%     'right_pFusFace_rl'
    'left_VWFA_rl'
%     'left_VWFA_lateral_rl'
%     'left_VWFA_medial_rl'
%     'lh_VWFA_fullField_rl'
%     'lh_VWFA_rl'
    }; 

% ret model stimulus type. 'Checkers', 'Words', 'FalseFont'
list_dtNames = {
    'Words'
%     'Checkers'
%     'WordLarge'
%     'WordSmall'
%     'FaceSmall'
%     'FaceLarge'
    };

list_rmNames = {
    'retModel-Words-css.mat'
%     'retModel-Checkers-css.mat'
%     'retModel-WordLarge-css.mat'
%     'retModel-WordSmall-css.mat'
%     'retModel-FaceSmall-css.mat'
%     'retModel-FaceLarge-css.mat'
    };

vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = true;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = true;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% whether or not to close
in.close = false; 

% save
dirSave = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/coverages/';
extSave = 'png'; 
saveDropbox = true; 


%% define some things

% number of rois to loop over
numRois = length(list_roiNames);

% number of rms to loop over
numDts = length(list_dtNames);

%%

for ii = list_subInds
    
    % change to subject 
    chdir(theList{ii})
    
    % start the view
    vw = initHiddenGray; 
    
    for kk = 1:numDts
        
        % this dt and rm
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
    
        % load the rm model
        pathRM = fullfile(pwd,'Gray', dtName, rmName);

        % set the view to the current dt
        % and load the ret model
        vw  = viewSet(vw ,'curdt', dtName); 
        vw  = rmSelect(vw , 1, pathRM);
        vw  = rmLoadDefault(vw); 

        for jj = 1:numRois

            roiName = list_roiNames{jj};

            % path of roi
            d = fileparts(vANATOMYPATH); 
            pathRoi = fullfile(d,'ROIs',roiName); 

            % load the roi
            % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
            vw  = loadROI(vw , pathRoi, [],[],1,0); 

            % get the rm params for that roi
            rmROI = rmGetParamsFromROI(vw ); 

            % plot the coverage of the roi
            rmPlotCoveragefromROImatfile(rmROI,vfc)

            % title
            thisSub         = list_sub{ii}; 
            plotDescript    = ff_stringRemove(rmName, 'retModel-');
            titleName       = [roiName(1:end-3) '-' thisSub '-' plotDescript];
            title(titleName, 'FontWeight', 'Bold', 'FontSize', 18)
            
            % save the coverage
            saveas(gcf, fullfile(dirSave, vfc.method,  [titleName '.png']), 'png'); 
            saveas(gcf, fullfile(dirSave, vfc.method,  [titleName '.fig']), 'fig'); 
            if saveDropbox, ff_dropboxSave; end
            
            
        end
        
    end
    
    % close the coverage plots
    if in.close
        close all; 
    end
    
end