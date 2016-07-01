%% distribution of amplitudes for a given pixel in the visual field coverage
% For PIXELS in the visual field map, plot the distribution of the receptive field amplitudes it sees

clear all; close all; clc; 
bookKeeping; 

%% modify here

% pixel that we're interested in
pixNum = 8272; 
% Fo 128 pixels and 15 degrees, 1 pix = 0.12 deg and 1 deg = 8.53 pix
% note that there is a y-flip!
%
% 8272 - right horizontal merdian. 3.25 deg
% 8288 - right horizontal meridian. 7.5 deg
% 8256 - fovea

% subject to analyze, indices defined in bookKeeping
subToAnalyze = 2; 

% rois we're interested in
roiName = 'LV2d_rl';
% 'lh_VWFA_rl'
% 'LV1_rl'

% number of bins in the histogram
numBins = 10; 

% ret model type
rmName = 'Checkers'; 

% contour level of the pRF coverage (which is normalized between 0 and 1)
% not used in pixel distribution, but is in the title for additional info
contourLevel = 0.8; 

% vfc parameters
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                          
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
vfc.eccthresh       = [0 12]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = 0;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% figure size/position. Saving as a png has weird proportions if we don't
% specify this.
% [x y width height]
figPos = [1976 127 1200 520]; 

% save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/pixDist'; 
saveExt = 'png';


%%

% transform the pixel number into cartesian coordinates. origin is at fovea
[visAngX, visAngY] = ff_pixNum2Cart(pixNum, vfc); 

% change to directory and load the view
dirVista = list_sessionPath{subToAnalyze}; 
chdir(dirVista); 
mrVista('3'); 

% load the ret model
pathRM = fullfile(dirVista, 'Gray', rmName, ['retModel-' rmName '.mat']);
VOLUME{1} = rmSelect(VOLUME{1}, 1, pathRM); 
VOLUME{1} = rmLoadDefault(VOLUME{1});

% load the roi
d = fileparts(vANATOMYPATH); 
pathROI = fullfile(d, 'ROIs', roiName); 
VOLUME{1} = loadROI(VOLUME{1}, pathROI, [],[], 1, 0); 

% grab the rm roi struct
rmROI = rmGetParamsFromROI(VOLUME{1});

% plot the coverage!
[rf, figHandle2, all_models, weight, data] = rmPlotCoveragefromROImatfile(rmROI, vfc); 

% plot the location of the pixel of interest
plot(visAngX, visAngY, '.b', 'MarkerSize', 24, 'MarkerEdgeColor', [1 0 0])

% calculate coverage percent and coverage area
[covAreaPercent, covArea] = ff_coverageArea(contourLevel, vfc, rf); 

axHandle2   = gca; 
fig2        = get(axHandle2, 'children'); 


%% Plotting -----------------------------------------------------------
% plot the distribution
figHandle1  = figure; 
hist(all_models(pixNum, :))
titleName   = [roiName(1:end-3) '. ' list_sub{subToAnalyze} '. '...
    rmName '. PixNum: ' num2str(pixNum)]; 
axHandle1   = gca;
fig1        = get(axHandle1, 'children'); 


% copy to a subplot
F = figure; 

% properties of left panel: histogram
s1 = subplot(1,2,1); % create and get handle to the subplot axes
xlabel('Amplitude of pRF')
ylabel('Number of Voxels')
set(gca, 'XLim', [0 1])
title(titleName, 'FontWeight', 'Bold')
colormap gray
grid on 

% properties of right panel: coverage
s2 = subplot(1,2,2); % create and get handle to the subplot axes
title({'Visual Field Location', ...
    ['Coverage Area (' num2str(contourLevel) ' threshold) : ' num2str(covArea) ' deg^2'], ...
    [num2str(covAreaPercent*100) '% of the visual field']}); 
colormap gray
axis off 

% copy to subplot
copyobj(fig1, s1); 
copyobj(fig2, s2); 

% color bar for coverage
colorbar; 

% change the size of the figure
set(gcf,'Position', figPos)

% save
saveas(gcf, fullfile(saveDir, [titleName '.' saveExt]), saveExt); 

