%% plots the average (over subjects) coverage area in an roi
% for different types of stimulus
clear all; close all; clc
bookKeeping; 

%% modify here
% roi to calculate coverage area for
roiName = 'lh_VWFA_rl'; 
% lh_VWFA_rl

% coverage threshold
% everything with this value or greater will be included in calculating area
contourLevel = 0.8; 

% the rm models to compare
list_rmNames = {
    'Checkers'; 
    'Words'; 
    'FalseFont';
};

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


dirSave = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/working'; 
extSave = 'png'; 

%%

% number of subjects
numSubs = length(list_sessionPath); 

% number of ret models to compare
numRMs = length(list_rmNames);

% Areas is a numRMs x numSubs matrix where Areas(i,j) is the area 
% corresponding to the ith rm model in the jth subject
Areas = zeros(numRMs, numSubs); 

for ii = 1:numSubs
    
    % load the view
    chdir(list_sessionPath{ii}); 
    vw = initHiddenGray; 
        
    % load the roi
    % [vw, ok] = loadROI(vw, filename, [select], [color], [absPathFlag], [local=1])
    d = fileparts(vANATOMYPATH); 
    pathROI = fullfile(d,'ROIs',roiName);
    vw = loadROI(vw, pathROI, [],[],1,0);
    
    for kk = 1:numRMs

        % load the ret model
        rmName = list_rmNames{kk}; 
        pathRM = fullfile(list_sessionPath{ii}, 'Gray', rmName, ['retModel-' rmName '.mat']); 
        vw = rmSelect(vw, 1, pathRM); 

        % get the roi rm struct
        roiRM = rmGetParamsFromROI(vw);

        % get the coverage
        [rf,~,~,~,~] = rmPlotCoveragefromROImatfile(roiRM,vfc); 

        % calculate the area
        covArea = ff_coverageArea(contourLevel, vfc, rf); 
        
        % store
        Areas(kk,ii) = covArea; 
        
    end
end

% get the mean and std over subjects for each stimulus type
meanAreas = mean(Areas,2); 
stdAreas  = sqrt(var(Areas,[],2)./numSubs);

%% plot
close all; 
figure();
errorbar([1:numRMs],meanAreas, stdAreas, '.k', 'MarkerSize', 24)
set(gca, 'XTick', [1:numRMs]); 
set(gca, 'XTickLabel', list_rmNames); 
axis([0 (numRMs+1) 0 1])
ylabel('Area')
grid on
titleName = {['Coverage Area in ' roiName], ['Contour Level: ' num2str(contourLevel)]}; 
title(titleName, 'FontWeight', 'Bold'); 


% save
saveas(gca, fullfile(dirSave, [titleName{1} '.' extSave]), extSave); 
