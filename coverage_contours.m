%% script to make contour coverages for different thresholds
clear all; close all; clc; 
bookKeeping; 

%% modify here

% subjects we want to make this contour plot for 
subsToSee = 1%1:length(list_sessionPath);

% the rois we're interested in
roiName = 'lh_VWFA_rl';
% 'lh_VWFA_rl'

% ret model stimulus type - 'Checkers' 'Words' 'FalseFont'
rmName = 'Words'; 

% save directory
dirSave = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/contours'; 

% save extension
extSave = 'png';

% contour level for calculating area
contourLevel = 0.8; 

% rm mat file name
rmMatFile = ['retModel-' rmName '.mat']; 
% rmMatFile = ['retModel-' rmName '-' roiName '.mat']; 

% parameters for making prf coverage
vfc.fieldRange      = 15;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.method          = 'max';                    % method for doing coverage.  another choice is density
vfc.newfig          = 0;                        % any value greater than -1 will result in a plot
vfc.nboot           = 50;                       % number of bootstraps
vfc.normalizeRange  = true;                     % set max value to 1
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  so takes the 
                                                % median of all sigmas within
vfc.cothresh        = 0.2;        
vfc.eccthresh       = [.2 12]; 
vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment
vfc.weight          = 'variance explained';     % another option is 'fixed'
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = 1;                        % print stuff or not
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;


%% no need to modify below here

for ii = subsToSee; 

    % subject's mrSESSION
    thisSub     = list_sub{ii}; 
    dirVista = list_sessionPath{ii}; 
    chdir(dirVista); 

    % open mrVista
    vw = initHiddenGray; 

    % specify shared roi directory
    d = fileparts(vANATOMYPATH); 
    dirRoiShared = fullfile(d, 'ROIs'); 

    % path of the rm file
    pathRMfile = fullfile(dirVista, 'Gray',rmName, rmMatFile); 

    % load the retintopic model
    vw = rmSelect(vw,1,pathRMfile); 
    vw = rmLoadDefault(vw); 
    
        
    % load the rois (automatically selects the one that is just loaded)
    vw = loadROI(vw, fullfile(dirRoiShared,roiName), [],[],1,0);
    vw = viewSet(vw,'selectedRoi',roiName); 

    rm = rmGetParamsFromROI(vw);

    % [RFcov, figHandle, all_models, weight, data] = rmPlotCoveragefromROImatfile(rm,vfc)
    [rf,~,~,~,~] = rmPlotCoveragefromROImatfile(rm,vfc); 

    % get the coverage area
    covArea = ff_coverageArea(contourLevel, vfc, rf); 

    % plot the contours 
    ff_pRFasContours(rf, vfc)
    title({[roiName(1:end-3) ' :' thisSub], ['Coverage Area for ' num2str(contourLevel) ': ' num2str(covArea)]}); 

    % save
    nameSave    = [roiName(1:end-3) '-' thisSub '-' rmName]; 
    pathSave    = fullfile(dirSave, vfc.method,  [nameSave '.' extSave]); 
    saveas(gcf, pathSave, extSave); 

    close all

   
end


