%% plot contours (bootstrapped) on an individual level basis
% we will get a CI if we do it for mutliple ret models --

clear all; close all; clc; 
bookKeeping; 

%% modify here

% the group we want to sample over, as indicated by bookKeeping
list_subInds = 1:20;

% which session? {'list_sessionPath'| 'list_sessionRetFaceWord'}
list_path = list_sessionRet; % list_sessionPath; % list_sessionSizeRet;

% the roi we're interested in

list_roiNames = {
    'left_VWFA_rl'
    };

% datatype names
% ff_stringRemoveSweeps('Words_Remove_Sweep', 8,[])
list_dtNames = {
    'Words'
    };

% rm names
% ff_stringRemoveSweeps('retModel-Words_Remove_Sweep', 8, '-css.mat');
list_rmNames = {
    'retModel-Words-css.mat'
    };

% contour level
list_contourLevels = [
    .9
    ];

% vfc threshold
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.2;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = true;
vfc.cmap            = 'gray';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = true;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;
vfc.backgroundColor = [.9 .9 .9]; 
vfc.ellipsePlot     = false; 
vfc.ellipseLevel    = 0.9;
vfc.ellipseColor    = [1 0 0];
vfc.contourPlot     = false; 
vfc.contourLevel    = 0.9; 
vfc.contourColor    = [.2 .2 .2];
vfc.contourBootstrap= true; 


% save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/contours/CI';
saveDropbox = true; 

% comment out this line if we don't want to directly alter colormap
% newcolormap = 0.3 + 0.6*gray(9);
% newcolormap = gray(8); 

%% calculate and define things

numSubs = length(list_subInds);
numDts = length(list_dtNames);
numRois = length(list_roiNames);


%% loop over subjects

for ii = list_subInds
   
    dirVista = list_path{ii};
    dirAnatomy = list_anatomy{ii};
    subInitials = list_sub{ii};
    chdir(dirVista); 
    vw = initHiddenGray; 
    
    % loop over ret models
    for kk = 1:numDts
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
        vw = rmSelect(vw,1,rmPath);
        vw = rmLoadDefault(vw);
        
        % loop over rois
        for jj = 1:numRois
            
            roiName = list_roiNames{jj};
            roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
            vw = loadROI(vw, roiPath, [],[],1,0);
            
            % get the rmroi
            rmroi = rmGetParamsFromROI(vw);
            
            % get the all the data from plotting the coverage
            [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rmroi,vfc);
            
            % title
            roiNameDescript = ff_stringRemove(roiName, '_rl');
            
            titleName = {['Bootstrapped (' num2str(vfc.nboot) ') Coverage. ' roiNameDescript] [dtName ' . ' subInitials]};
            title(titleName, 'fontweight', 'bold');
            
            
            % save
            ff_dropboxSave; 
            
        end % loop over rois
        
    end % loop over ret models
    
end % loop over subjects
