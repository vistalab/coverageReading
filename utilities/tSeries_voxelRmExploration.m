%% for voxels in an roi, look at rm fields
clear all; close all; clc; 
bookKeeping; 

%% modify here

subInd = 1; 

% roiNames
% ASSUME ONE ROI FOR NOW
list_roiNames = {'LV2v_rl-threshBy-WordsAndCheckers-co0p5'}; 

% ret models
list_dtNames = {
    'Words'
    'Words'
%     'FalseFont'
    };
list_rmNames = {
    'retModel-Words-css.mat';
    'retModel-Words-css.mat';
%     'retModel-FalseFont-css.mat';
    };
list_rmDescripts = {
    'Words CSS'
    'Words CSS'
    };

% vfc thresh
vfc = ff_vfcDefault; 


%% get the rmroi for each ret model
rmroiCellTemp = ff_rmroiCell(subInd, list_roiNames, list_dtNames, list_rmNames);

% threshold 
rmroiCell = ff_rmroiGetSameVoxels(rmroiCellTemp, vfc); 

%% get the coodinates for the ROI
% and also load the retmodel
dirVista = list_sessionRet{subInd}; 
dirAnatomy = list_anatomy{subInd}; 

chdir(dirVista); 
vw = initHiddenGray;

roiName = list_roiNames{1};
roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
vw = loadROI(vw, roiPath,[],[],1,0); 

% roiCoords is a 3 x numCoords matrix
[~, roiCoords] = roiGetAllIndices(vw); 

%% useful
rmroiFull = rmroiCellTemp{1}; 
numRms = length(list_rmNames); 
numVoxels = length(rmroiFull.co)

%% specifically interested in ...
rmroi1 = rmroiCell{1}; 
rmroi2 = rmroiCell{2}; 

vfc.cothresh = 0.82; 
coInds = rmroi1.co > vfc.cothresh & rmroi2.co > vfc.cothresh; 

eccInds = (abs(rmroi1.ecc - rmroi2.ecc)) > -1; 

sigInds = (abs(rmroi1.sigma - rmroi2.sigma)) > -1; 

indInds = coInds & eccInds & sigInds; 
numVoxelsPassed = sum(indInds)

%% get a sense of the data

indx = find(indInds)

T = table;  
T.indx = indx'; 
T.varExp1 = rmroi1.co(indx)';
T.varExp2 = rmroi2.co(indx)';
T.ecc1 = rmroi1.ecc(indx)';
T.ecc2 = rmroi2.ecc(indx)';
T.sigEff1 = rmroi1.sigma(indx)'; 
T.sigEff2 = rmroi2.sigma(indx)';

display(['rm1: ' list_dtNames{1}])
display(['rm2: ' list_dtNames{2}])
T

%% plotting

% get coordinate information
coordInd = 58; 
% coordInd = 15; % sub 4. LhV4_rl
% coordInd = 734; 


% close all; 
% loop over the ret models
for kk = 1:numRms
    
    rmDescript = list_rmDescripts{kk};
    rmroi = rmroiCell{kk};
    rmroiCoord = ff_rmroi_subset(rmroi, coordInd); 
        
    co = rmroiCoord.co; 
    ecc = rmroiCoord.ecc;
    sig1 = rmroiCoord.sigma1;
    sigEff = rmroiCoord.sigma;
    x = rmroiCoord.x0; 
    y = rmroiCoord.y0;
    exponent = rmroiCoord.exponent; 
    theCoords = rmroiCoord.coords; 
    
    dtName = list_dtNames{kk};
    rmName = list_rmNames{kk};
    rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
    
    vw = viewSet(vw, 'curdt', dtName); 
    nFrames = viewGet(vw, 'nframes');
    
    vw = rmSelect(vw, 1, rmPath); 
    vw = rmLoadDefault(vw); 
    
    %% get the predicted time series
    [prediction, ~, ~, varexp] = rmPredictedTSeries(vw, theCoords, [], [], []);
       
    %% get the actual time series
    [tSeriesCell, ~] = getTseriesOneROI(vw,theCoords,[], 0, 0 );
    tSeries = tSeriesCell{1}; 
    clear tSeriesCell;
    
    %% plotting the time series
    figure; hold on; 
    plot(1:nFrames, prediction, 'linewidth',2, 'color', [0 0 1]); 
    plot(1:nFrames, tSeries, 'marker', '.', 'color', [0 0 0]);
    
    grid on; 
    titleName = {
        [rmDescript '. Sub' num2str(subInd) '. ' ff_stringRemove(roiName, '_rl')]
        ['coord: ' num2str(theCoords')]
        ['Var exp: ' num2str(co)]
        ['Ecc: ' num2str(ecc)]
        ['Sigma major: ' num2str(sig1)]
        ['Sigma effective:' num2str(sigEff)]
        ['Exponent: ' num2str(exponent)]
    };

    title(titleName, 'fontsize',14)
    
    %% plotting the single pRF
    figure; 
        
    % the function ff_pRFasCircles uses sigma1 and sigma2 to plot the size.
    % Sometimes we want to plot the effective sigma. 
    % so make a new rm struct that has the sigma that we want
    rm = rmroiCoord; 
    rm.sigma1 = rmroiCoord.sigma; 
    rm.sigma2 = rmroiCoord.sigma;     
    vfc = ff_vfcDefault; 
    plotOnlyCenters = false; 

    %% do it
    ff_pRFasCircles(rm, vfc, plotOnlyCenters)
    set(gca, 'fontsize', 8)
    title(titleName)

end

