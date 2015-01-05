%% script to make contour coverages for different thresholds
clear all; close all; clc; 
%% modify here

% path with mrSESSION
pathSESSION = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';

% directory of rmModel (relative to mrSESSION)
dirRMfile = 'Gray/WordRetinotopy/';

% directory of roi
dirRoiShared = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% the rois we're interested in
list_roiNames = {
    'leftVWFA';
%     'rightVWFA';
     };

list_rmFiles = {
    [pathSESSION dirRMfile 'rmImported_retModel-15degWords_fixation_grayBg.mat']; 
%     [pathSESSION dirRMfile 'rmImported_retModel-15deg-FalseFont-GrayBg-fFit.mat'];
%     [pathSESSION dirRMfile 'rmImported_15degChecker-20141129-212149-fFit.mat']; 
%     [pathSESSION dirRMfile 'rmImported_retModel-15deg-WordsWhiteBg-Helvetica-Fixation-fFit.mat']; 
    };
 

% threshold values of the rm model
h.threshco      = 0.3;       % minimum of co
h.threshecc     = [.2 15];   % range of ecc
h.threshsigma   = [0 15];    % range of sigma
h.minvoxelcount = 10;        % minimum number of voxels in roi

% parameters for making prf coverage
vfc.fieldRange      = 16;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.method          = 'maximum profile';        % method for doing coverage.  another choice is density
vfc.newfig          = 0;                     % any value greater than -1 will result in a plot
vfc.nboot           = 0;                     % number of bootstraps
vfc.normalizeRange  = true;                     % set max value to 1
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  so takes the 
                                                % median of all sigmas within
vfc.cothresh        = h.threshco;        
vfc.eccthresh       = h.threshecc; 
vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment
vfc.weight          = 'fixed';  
vfc.weight          = 'variance explained';
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = 1;                        % print stuff or not
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;

%% no need to modify below here

% open mrVista
vw = mrVista('3'); 

%%
for ii = 1:length(list_rmFiles)
   
    % load the retintopic model
    vw = rmSelect(vw,1,list_rmFiles{ii}); 
    vw = rmLoadDefault(vw); 
    
    for jj = 1:length(list_roiNames)
        
        % load the rois (automatically selects the one that is just loaded)
        vw = loadROI(vw, [dirRoiShared list_roiNames{jj}], [],[],1,0);
        vw = viewSet(vw,'selectedRoi',list_roiNames{jj}); 
        
        rm = rmGetParamsFromROI(vw);
        rm.session = pathSESSION;  
        rm.subject = ''; 
        
        % [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rm,vfc)
        [rf,~,~,~,~] = rmPlotCoveragefromROImatfile(rm,vfc); 
        
        ff_pRFasContours(rf, vfc)
        title(list_roiNames{jj})
    
    end
    
end


%% make a single contour map
% this will probably go into it's own function very soon

% grab the roi


% grab <rf> from rmPlotCoverage