%% script to make contour coverages for different thresholds
% Code skeleton:
% - define the specific contour 
% - loop over different thresholds and get this contour, store in a matrix
% - plot the matrix as a contour

clear all; close all; clc; 
%% modify here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% how to plot the coverage: 'max' 'sum'
h.prfCoverageMethod   = 'max';
% contour level (across which we will vary threshold)
h.prfContourLevel     = 0.2; 

% threshold values of the rm model
% will be stored as a n x 1 cell

% threshold values
h.threshco      = { 
    0.1; 
    0.2;
    0.3;
    0.4;
    }; 

h.threshecc     = [.2 16];   % range of ecc
h.threshsigma   = [0 16];    % range of sigma
h.minvoxelcount = 10;        % minimum number of voxels in roi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% path with mrSESSION
path.session = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';

% directory of roi
path.dirRoi = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% the rois we're interested in
list.roiNames = {
    'leftVWFA';
    % 'rightVWFA';
     };

list.rmFiles = {
%     [path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-15degWords_fixation_grayBg.mat']; 
%     [path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-15deg-FalseFont-GrayBg-fFit.mat'];
%     [path.session 'Gray/WordRetinotopy/' 'rmImported_15degChecker-20141129-212149-fFit.mat']; 
%     [path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-15deg-WordsWhiteBg-Helvetica-Fixation-fFit.mat'];
% 
[path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-leftVWFA-CV1-fFit.mat'];
[path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-leftVWFA-CV2-fFit.mat']; 
[path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-leftVWFA-HelveticaGrayBg-1run-fFit.mat']; 

% [path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-rightVWFA-CV1-fFit.mat'];
% [path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-rightVWFA-CV2-fFit.mat'];
% [path.session 'Gray/WordRetinotopy/' 'rmImported_retModel-rightVWFA-HelveticaGrayBg-1run-fFit.mat'];
};
 
list.comments = {
    'run 1'
    'run 2'
    'run 3'
};

% parameters for making prf coverage
vfc.method          = h.prfCoverageMethod;        % method for doing coverage.  all choices: 
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
for ii = 1:length(list.roiNames)
    eval([list.roiNames{1} '_sbp = figure;'])
end


for ii = 1:length(list.rmFiles)
   
    % load the retintopic model
    vw = rmSelect(vw,1,list.rmFiles{ii}); 
    vw = rmLoadDefault(vw); 
    
    for jj = 1:length(list.roiNames)

        % load the rois (automatically selects the one that is just loaded)
        vw = loadROI(vw, [path.dirRoi list.roiNames{jj}], [],[],1,0);
        vw = viewSet(vw,'selectedRoi',list.roiNames{jj}); 
        
        rm = rmGetParamsFromROI(vw);
        rm.session = path.session;  
        rm.subject = ''; 
        
        %% grab the coverage map
        % [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rm,vfc)
        [rf,~,~,~,~] = ff_rmPlotCoveragefromROImatfile(rm,vfc,vw); 
        colormap hot
        title([list.roiNames{jj} '. ' list.comments{ii} '. ' vfc.method])
        
        %% grab the contour map
        ff_pRFasContours(rf, vfc);
        colormap gray
        title([list.roiNames{jj} '. ' list.comments{ii} '. ' vfc.method])
        grid on
        
    
    end
    
end
