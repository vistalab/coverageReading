%% pipeline

%% interested in the variance explained for different retinotopic models 
% (because they have different stimuli)

clear all; close all; clc; 
%% modify here
 
% session with mrSESSION.mat file. all the rm files should be imported here. 
path.session = '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/'; 

% short description, useful for plotting later
list.comments = {
    'Checkers';
    'Words';
    'FalseFont';
    };

% list of the corresponding rm files paths
list.rmFiles = {
    [path.session 'Gray/WordRetinotopy/rmImported_15degChecker-20141129-fFit.mat'];
    [path.session 'Gray/WordRetinotopy/rmImported_retModel-15degWords_fixation_grayBg.mat'];  
    [path.session 'Gray/WordRetinotopy/rmImported_retModel-15deg-FalseFont-GrayBg-fFit.mat']; 
    };

% modelsToCompare x-axis y-axis respectively
modelsToCompare = [1 2]; 

% directory of roi
% path.dirRoi = '/biac4/wandell/data/anatomy/khazenzon/ROIs/'; 
path.dirRoi = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% the rois we're interested in
% eventually make sure they are drawn with 15 deg ret
list.roiNames = {
    'leftVWFA';
    'LV1';
    'LV2d';
    'LV2v';
    'lh_pFus_Face1Face2_FastLocs';
    
    'rightVWFA';
    'RV1';
    'RV2d';
    'RV2v';
    'rh_pFus_Face1Face2_FastLocs';
     };

% save directory
dirSave = '/biac4/wandell/data/reading_prf/forAnalysis/images/single/varExplained/'; 

% for naming purposes
subid = 'rl'; 

% format that we want the to save visualizations as: 'fig' or 'png'
saveFormat = 'png'; 

% fontsize for graph sizes
fontSize = 13; 

% threshold values of the rm model
h.threshco      = 0.1;       % minimum of co
h.threshecc     = [.2 16];   % range of ecc
h.threshsigma   = [0 16];    % range of sigma
h.minvoxelcount = 0;        % minimum number of voxels in roi

% parameters for making prf coverage
vfc.fieldRange      = 16;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.method          = 'sum';                % method for doing coverage.  another choice is density
vfc.newfig          = 0;                     % any value greater than -1 will result in a plot
vfc.nboot           = 0;                     % number of bootstraps
vfc.normalizeRange  = true;                     % set max value to 1
vfc.smoothSigma     = true;                     % this smooths the sigmas in the stimulus space.  so takes the 
                                                % median of all sigmas within
vfc.cothresh        = h.threshco;        
vfc.eccthresh       = h.threshecc; 
vfc.nSamples        = 128;                      % fineness of grid used for making plots     
vfc.meanThresh      = 0;                        % threshold by mean map, no way to use this at the moment
vfc.weight          = 'variance explained';
vfc.weightBeta      = 0;                        % weight the height of the gaussian
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = 1;                        % print stuff or not
vfc.dualVEthresh    = 0;
vfc.binsize         = 0.5;


%% do it!
% turn off text interpreters so that plot titles are cleaner
set(0,'DefaultTextInterpreter','none'); 

% code that nathan has written. should move this to git
% addpath('/biac4/kgs/biac3/kgs4/projects/retinotopy/adult_ecc_karen/Analyses/pRF2sel'); 

% move to session directory
chdir(path.session); 

% open mrVista
vw = mrVista('3'); 

% make the rm struct
S = ff_rmRoisStruct(vw, list.rmFiles, list.roiNames, path); 

%% bookkeeping and thresholding
% seems extraneous but need for rmPlotROICoveragefrommatfile
modelx = modelsToCompare(1);
modely = modelsToCompare(2); 

% variable for subplot
sp2 = ceil(length(list.roiNames)/2); 

% figure handles
hVarExp     = figure; 
hSize       = figure; 
hEcc        = figure;  
hCoverage   = figure; 
 
%% plot prfCoverage (voxel by voxel) for both models %%%%%%%%%%%%%%%%%%%%
ff_rmRoisPlotCoverage(S, list, hCoverage, vfc)
    

for jj = 1:length(list.roiNames)

    % define the models 
    m1 = S{modelx,jj};
    m2 = S{modely,jj};  
    
    % threshold the RM structs based on thresholds we defined above
    indthresh_co = (m1.co > h.threshco) & (m2.co > h.threshco); 

    indthresh_ecc = ((m1.ecc > min(h.threshecc)) & m1.ecc < max(h.threshecc)) ...
     & ((m2.ecc > min(h.threshecc)) & m2.ecc < max(h.threshecc)); 

    indthresh_sigma = ((m1.sigma1 > min(h.threshsigma)) & m1.sigma1 < max(h.threshsigma)) ...
     & ((m2.sigma1 > min(h.threshsigma)) & m2.sigma1 < max(h.threshsigma)); 

    indthresh_co_ecc = indthresh_co & indthresh_ecc; 
    
    indthresh_co_sigma = indthresh_co & indthresh_sigma; 
    
    indthresh_ecc_sigma = indthresh_ecc & indthresh_sigma; 

    indthresh_co_ecc_sigma = indthresh_co_ecc & indthresh_sigma; 
    

    %% plot prf variance explained for both models %%%%%%%%%%%%%%%%%%%%%%%%%%

    figure(hVarExp) 
    subplot(2,sp2,jj); 
    % plot(m1.co,m2.co,'.'); 
    plot(m1.co(indthresh_ecc_sigma),m2.co(indthresh_ecc_sigma),'.');
    % ff_intensityHistogram(m1.co(indthresh_ecc_sigma), m2.co(indthresh_ecc_sigma), [0 1])

    title(['VarExp in ' list.roiNames{jj}], 'FontSize',fontSize); 
    xlabel(list.comments{modelx},'FontSize',fontSize);
    ylabel(list.comments{modely},'FontSize',fontSize);
    identityLine;  
    % saveas(gcf,[dirSave subid '_' list.roiNames{jj} '.mat'], num2str(saveFormat))
    
 
    %% plot prf size for both models %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure(hSize)
    subplot(2,sp2,jj);
    plot(m1.sigma1(indthresh_co_ecc),m2.sigma1(indthresh_co_ecc),'.'); 
    % ff_intensityHistogram(m1.sigma1(indthresh_co),m2.sigma1(indthresh_co),[])
    title(['prf size in ' list.roiNames{jj}], 'FontSize',fontSize); 
    xlabel(list.comments{modelx},'FontSize',fontSize);
    ylabel(list.comments{modely},'FontSize',fontSize);
    identityLine; 
    % saveas(gcf,[dirSave subid '_' list.roiNames{jj} '.mat'], num2str(saveFormat))
    


    %% plot prf ecc for both models %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure(hEcc)
    subplot(2,sp2,jj);
    plot(m1.ecc(indthresh_co_sigma),m2.ecc(indthresh_co_sigma),'.'); 
    title(['prf ecc ' list.roiNames{jj}], 'FontSize',fontSize); 
    xlabel(list.comments{modelx},'FontSize',fontSize);
    ylabel(list.comments{modely},'FontSize',fontSize);
    identityLine; 
    % saveas(gcf,[dirSave subid '_' list.roiNames{jj} '.mat'], num2str(saveFormat))
    
end

