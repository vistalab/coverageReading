%% script to make contour coverages for different thresholds
% Code skeleton:
% - define the specific contour 
% - loop over different thresholds and get this contour, store in a matrix
% - plot the matrix as a contour

clear all; close all; clc; 
%% modify here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% how to plot the coverage: 'max' 'sum'
prfCoverageMethod   = 'max';
% contour level (across which we will vary threshold)
prfContourLevel     = 0.2; 

% threshold values of the rm model
% will be stored as a n x 1 cell

% minimum of co
Hthreshco      = { 
    0.1; 
    0.2;
    0.3;
    0.4;
    }; 

Hthreshecc     = [.2 16];   % range of ecc
Hthreshsigma   = [0 16];    % range of sigma
Hminvoxelcount = 10;        % minimum number of voxels in roi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% path with mrSESSION
pathSESSION = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';

% directory of rmModel (relative to mrSESSION)
dirRMfile = 'Gray/WordRetinotopy/';

% directory of roi
dirRoiShared = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% the rois we're interested in
list_roiNames = {
    'leftVWFA';
    % 'rightVWFA';
     };

list_rmFiles = {
%     [pathSESSION dirRMfile 'rmImported_retModel-15degWords_fixation_grayBg.mat']; 
%     [pathSESSION dirRMfile 'rmImported_retModel-15deg-FalseFont-GrayBg-fFit.mat'];
%     [pathSESSION dirRMfile 'rmImported_15degChecker-20141129-212149-fFit.mat']; 
%     [pathSESSION dirRMfile 'rmImported_retModel-15deg-WordsWhiteBg-Helvetica-Fixation-fFit.mat'];
% 
[pathSESSION dirRMfile 'rmImported_retModel-leftVWFA-CV1-fFit.mat'];
[pathSESSION dirRMfile 'rmImported_retModel-leftVWFA-CV2-fFit.mat']; 
[pathSESSION dirRMfile 'rmImported_retModel-leftVWFA-HelveticaGrayBg-1run-fFit.mat']; 

% [pathSESSION dirRMfile 'rmImported_retModel-rightVWFA-CV1-fFit.mat'];
% [pathSESSION dirRMfile 'rmImported_retModel-rightVWFA-CV2-fFit.mat'];
% [pathSESSION dirRMfile 'rmImported_retModel-rightVWFA-HelveticaGrayBg-1run-fFit.mat'];
};
 
list_comments = {
    'run 1'
    'run 2'
    'run 3'
};

% parameters for making prf coverage
vfc.method          = prfCoverageMethod;        % method for doing coverage.  all choices: 
                                                % 'density' 'sum''max'
vfc.fieldRange      = 16;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers1
vfc.newfig          = 1;                        % any value greater than -1 will result in a plot
vfc.nboot           = 0;                        % number of bootstraps
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


% h.threshco      = 0.3;       % variance explained
% h.threshecc     = [.2 15];   % range of ecc
% h.threshsigma   = [0 15];    % range of sigma
% h.minvoxelcount = 10;        % minimum number of voxels in roi



%% no need to modify below here

% open mrVista
vw = mrVista('3'); 

%%
% define figure handles (figure that encloses subplot)
for ii = 1:length(list_roiNames)
    eval([list_roiNames{1} '_sbp = figure;'])
end


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
        
        %% grab the coverage map
        % [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rm,vfc)
        [rf,~,~,~,~] = ff_rmPlotCoveragefromROImatfile(rm,vfc,vw); 
        colormap hot
        title([list_roiNames{jj} '. ' list_comments{ii} '. ' vfc.method])
        
        %% grab the contour map
        ff_pRFasContours(rf, vfc);
        colormap gray
        title([list_roiNames{jj} '. ' list_comments{ii} '. ' vfc.method])
        grid on
        
    
    end
    
end
