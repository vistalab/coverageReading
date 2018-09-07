%% plot for the same vox, overlapping pRFs
clear all; close all; clc; 
bookKeeping; 

%% modify here

subInd = 20; 

% roiNames
% ASSUME ONE ROI FOR NOW
% list_roiNames = {'LV2v_rl-threshBy-WordsAndCheckers-co0p5'}; 
list_roiNames = {'lVOTRC'};

% ret models
list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat';
    'retModel-Checkers-css.mat';
    };
list_rmDescripts = {
    'Words'
    'Checkers'
    };

% vfc thresh
vfc = ff_vfcDefault; 

% colors for each rm
list_rmColors = [
    [1 0 0]
    [0 0 1]
    ];


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
% NOTE THIS ASSUMES ONE SUBJECT ONE ROI
rmroiFull = rmroiCellTemp{1,1,1}; 
rmroi = rmroiCell{1,1,1};

numRms = length(list_rmNames); 
numVoxelsAll = length(rmroiFull.co); % all voxels in roi definition
numVoxels = length(rmroi.co);

%% specifically interested in ...
rmroi1 = rmroiCell{1}; 
rmroi2 = rmroiCell{2}; 

vfc.cothresh = .2; 
coInds = rmroi1.co > vfc.cothresh & rmroi2.co > vfc.cothresh; 

% eccInds = rmroi2.ecc > 0;
% eccInds = (abs(rmroi1.ecc - rmroi2.ecc)) < 10; % rmroi2.ecc < 11
% sigInds = (abs(rmroi1.sigma - rmroi2.sigma)) < 4; 
% ellipseInds = (abs(rmroi2.sigma1 - abs(rmroi2.sigma2))) > -1;

eccInds = ones(1, numVoxels); 
sigInds = ones(1, numVoxels);
ellipseInds = ones(1, numVoxels);

indInds = coInds & eccInds & sigInds & ellipseInds; 
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
coordInds = 1:numVoxels; 

close all; 
% loop over coordinates
for cc = 1:length(coordInds)

    figure; 
    coordInd = coordInds(cc);
    
    % loop over the ret models
    for kk = 1:numRms

        rmDescript = list_rmDescripts{kk};
        rmroi = rmroiCell{kk};
        rmroiCoord = ff_rmroi_subset(rmroi, coordInd); 
        rmColor = list_rmColors(kk,:);

        co = rmroiCoord.co; 
        ecc = rmroiCoord.ecc;
        sig1 = rmroiCoord.sigma1;
        sig2 = rmroiCoord.sigma2;
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


        %% plotting the single pRF

        % the function ff_pRFasCircles uses sigma1 and sigma2 to plot the size.
        % Sometimes we want to plot the effective sigma. 
        % so make a new rm struct that has the sigma that we want
        rm = rmroiCoord; 
        rm.sigma1 = rmroiCoord.sigma; 
        rm.sigma2 = rmroiCoord.sigma;     
        vfc = ff_vfcDefault; 
        plotOnlyCenters = false; 

        %% do it
        ff_pRFasCircles(rm, vfc, plotOnlyCenters, 'faceColor', rmColor);
        set(gca, 'fontsize', 8);

    end

    % plot title
    titleName = {
        ['Sub: ' num2str(subInd) '. ' roiName]
        ['Voxel: ' num2str(rm.coords')]
        };
    title(titleName, 'fontweight', 'bold');

end

    