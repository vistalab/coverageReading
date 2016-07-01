%% Reading circuitry field of view paper (2016). Making figures

% Uses this script:  coverage_contourOutline_withinIndividual.m
%% for an individual, plot {contourLevel} contours from multiple stmi type
% example use: coverage is a lot larger for checkers
% show this in the individual

clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects and session
list_subInds = 1:20%16:22
list_path = list_sessionRet; 

% roi
roiName = 'left_VWFA_rl';

% saving purposes, should be informative
% can also be empty
titleDescript = 'Words. Same voxels'; 

list_dtNames = {
%     'Checkers'
%     'Checkers1and2'
%     'Checkers2and3'
%     'Checkers1and3'
    'Words'
    'Words1'
    'Words2'
    };

list_rmNames = {
%     'retModel-Checkers-css.mat'
%     'retModel-Checkers1and2-css-left_VWFA_rl.mat'
%     'retModel-Checkers2and3-css-left_VWFA_rl.mat'
%     'retModel-Checkers1and3-css-left_VWFA_rl.mat'
    'retModel-Words-css.mat'
    'retModel-Words1-css.mat'
    'retModel-Words2-css.mat'
    };

list_forLegend = {
%     '3 runs'
%     '2 runs'
%     '2 runs'
%     '2 runs'
    '2 runs'
    'Run1'
    'Run2'
    };

legendDescript = list_forLegend;  % list_rmNames

list_colors = {
    [ 0.4745    0.3412    0.6235] % purple
    [1.0000    0.5373         0] % orange
    [0.1333    0.6314    0.7294] % teal
    };

contourLevel = 0.9; 

% vfc parameters
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                        
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.2;         
vfc.eccthresh       = [0 15]; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = 0;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = false;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;
vfc.backgroundColor = [.95 .95 .95];
vfc.color           = [1 0 0]; % yet to figure out what this does
vfc.fillColor       = [0 1 0]; % yet to figure out what this does 
vfc.tickLabel       = false; 

% save
saveDropbox = true; 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/contours/CI';


%% compute basic things
% number of ret models
numDts = length(list_dtNames); 

%% loop over subjects
for ii = list_subInds
    
    % dirVista
    dirVista = list_path{ii};
    chdir(dirVista);
    vw = initHiddenGray; 
    subInitials = list_sub{ii}; 
    
    % load roi
    dirAnatomy = list_anatomy{ii}; 
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
    [vw, roiExists] = loadROI(vw, roiPath, [],[], 1,0);
    
    % initialize final 3D contour matrix (for subject)
    % assumption = bgcolor is a shade of gray
    bgcolor = vfc.backgroundColor(1); 
    ContourMatrix3D = bgcolor*ones(vfc.nSamples, vfc.nSamples, 3); 
    
    % initialize for each subject
    rmroiCell = cell(1, numDts);% initialize
    contourCoords = cell(2,numDts);
    
    for kk = 1:numDts
        
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
        rmExists = exist(rmPath, 'file');
        
        % if both rm and roi exists
        if roiExists && rmExists
            
            vw = rmSelect(vw, 1, rmPath); 
            vw = rmLoadDefault(vw);
            rmroi = rmGetParamsFromROI(vw); 
            rmroi.sub = subInitials; 
            
            % store the list of all rmrois so we can find the intersection
            % of all of them
            rmroiCell{kk} = rmroi; 
        end
    end
    
    % Cell where each element has an rmroi. 
    % All elements of this outputted cell are of the same voxels
    rmroiCellSameVox = ff_rmroiGetSameVoxels(rmroiCell, vfc);
    for kk = 1:numDts
        rmroiSame = rmroiCellSameVox{kk};
        
        RFcov = rmPlotCoveragefromROImatfile(rmroiSame, vfc);

        % get the x and y points of the specified contour level
        [contourMatrix, contourCoordsX, contourCoordsY] = ...
            ff_contourMatrix_makeFromMatrix(RFcov,vfc,vfc.ellipseLevel);

        % transform so that we can plot it on the polar plot
        contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
        contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange;

        % store
        contourCoords{1,kk} = contourX; 
        contourCoords{2,kk} = contourY; 
    end 
    
    %% plot! TODO: make into function
    close all; 
    
    % add polar grid on top
    p.ringTicks = (1:3)/3*vfc.fieldRange;
    p.color = 'w';
    p.backgroundColor = vfc.backgroundColor;
    p.tickLabel = vfc.tickLabel; 
    polarPlot([], p);
    hold on; 
    
    
    % add pRF centers if requested
    if vfc.addCenters,
        inds = data.subEcc < vfc.fieldRange;
        plot(data.subx0(inds), data.suby0(inds), '.', ...
            'Color', [.5 .5 .5], 'MarkerSize', 4);
    end
    
    % loop through contours
    for kk = 1:numDts
        
        contourColor = list_colors{kk};
        x = contourCoords{1,kk};
        y = contourCoords{2,kk};
        
        plot(x,y,'-', 'Color',contourColor, 'LineWidth',2)
        
    end
    
    
    %% plot properties
    
    % dummy objects so can associate legend with color
    p = zeros(numDts,1); 
    for pp = 1:numDts
        hold on; 
        p(pp) = plot(0,0,'Color',list_colors{pp});       
    end
    L = legend(p,legendDescript, 'Location', 'SouthOutside'); 
    
    % title
    roiNameDescript = ff_stringRemove(roiName, '_rl'); 
    titleName = {
        ['Contour Coverage within individual.' roiNameDescript '. ' subInitials '.' titleDescript];
        ['ContourLevel: ' num2str(contourLevel)];
        mfilename;
        };
    title(titleName, 'FontWeight', 'Bold')
    
    % save
    
    % because colors not saved as printed
    set(gcf, 'inverthardcopy', 'off');
    
    titleNameString = ff_cellstring2string(titleName); 
    ff_savePngAndFig(saveDir, titleNameString); 
    if saveDropbox
        ff_dropboxSave; 
    end
    
end % loop over subjects

