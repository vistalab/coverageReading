%% the comparison of rm models
% different stimuli, different models, etc

clear all; close all; clc; 
bookKeeping;

%% modify here
 
% subject we want to look at
subToAnalyze = 1; 
pth.dirVista = list_sessionPath{subToAnalyze}; 

% list of the corresponding rm files pths
list.rmFiles = {
    fullfile(pth.dirVista, 'Gray', 'Words','retModel-Words.mat'); 
    fullfile(pth.dirVista, 'Gray', 'Words','retModel-Words-CSS-fFit.mat');
    };

% modelsToCompare x-axis y-axis respectively
modelsToCompare = [1 2]; 

% short description, useful for plotting later
list.comments = {
    'linear fine fit (words)'; 
    'css fine fit (words)'; 
    };

% the rois we're interested in (no .mat at the end!)
% eventually make sure they are drawn with 15 deg ret
list.roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'lh_VWFA_rl'
    'lh_pFus_Face_rl'
     };

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/rmComparison'; 

% format that we want the to save visualizations as: 'fig' or 'png'
saveExt = 'png'; 

% fontsize for graph sizes
fontSize = 13; 

% threshold values of the rm model
h.threshco      = 0.1;       % minimum of co
h.threshecc     = [.2 16];   % range of ecc
h.threshsigma   = [.2 16];    % range of sigma
h.minvoxelcount = 0;        % minimum number of voxels in roi

% parameters for making prf coverage
vfc.fieldRange      = 15;                       % radius of stimulus
vfc.prf_size        = true;                     % if 0 will only plot the centers
vfc.method          = 'max';                % method for doing coverage.  another choice is density
vfc.newfig          = 0;                     % any value greater than -1 will result in a plot
vfc.nboot           = 50;                     % number of bootstraps
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

% move to session directory
chdir(pth.dirVista); 

% open mrVista
vw = mrVista('3'); 

% define shared roi directory 
d = fileparts(vANATOMYPATH); 
pth.dirRoi = fullfile(d, 'ROIs'); 

% make the rm struct
S = ff_rmRoisStruct(vw, list.rmFiles, list.roiNames, pth); 

% for naming purposes
subid = list_sub{subToAnalyze} ; 

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
ff_rmRoisPlotCoverage(S, list, hCoverage, vfc);
saveas(gcf,fullfile(saveDir, ['pRF Coverage. ' subid  '.' saveExt]), saveExt)
    

for jj = 1:length(list.roiNames)

    roiName = list.roiNames{jj}; 
    
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
    plot(m1.co(indthresh_ecc_sigma),m2.co(indthresh_ecc_sigma),'.k');
    % ff_intensityHistogram(m1.co(indthresh_ecc_sigma), m2.co(indthresh_ecc_sigma), [0 1])
    xlabel(list.comments{modelx},'FontSize',fontSize);
    ylabel(list.comments{modely},'FontSize',fontSize);
    identityLine;  
    axis square
    
    titleName = ['VarExp in ' roiName(1:(end-3)) ' . ' subid]; 
    title(titleName, 'FontSize',fontSize, 'FontWeight', 'Bold'); 
    saveas(gcf,fullfile(saveDir, [titleName '.' saveExt]), saveExt); 
    
 
    %% plot prf size for both models %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure(hSize)
    subplot(2,sp2,jj);
    plot(m1.sigma(indthresh_co_ecc_sigma),m2.sigma(indthresh_co_ecc_sigma),'.k'); 
    % ff_intensityHistogram(m1.sigma1(indthresh_co),m2.sigma1(indthresh_co),[]) 
    xlabel(list.comments{modelx},'FontSize',fontSize);
    ylabel(list.comments{modely},'FontSize',fontSize);
    identityLine; 
    axis square
    
    titleName = ['prf size in ' roiName(1:(end-3)) ' .' subid]; 
    title(titleName, 'FontSize',fontSize, 'FontWeight', 'Bold')
    saveas(gcf,fullfile(saveDir, [titleName '.' saveExt]), saveExt); 
    

    %% plot prf ecc for both models %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    figure(hEcc)
    subplot(2,sp2,jj);
    plot(m1.ecc(indthresh_co_ecc_sigma),m2.ecc(indthresh_co_ecc_sigma),'.k'); 
    xlabel(list.comments{modelx},'FontSize',fontSize);
    ylabel(list.comments{modely},'FontSize',fontSize);
    identityLine; 
    axis square
    
    titleName = ['prf ecc ' roiName(1:(end-3)) ' .' subid];
    title(titleName, 'FontSize', fontSize, 'FontWeight','Bold'); 
    saveas(gcf,fullfile(saveDir, [titleName '.' saveExt]), saveExt); 
    
end

