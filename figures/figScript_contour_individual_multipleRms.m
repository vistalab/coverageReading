%% coverage with contours 

close all; clear all; clc; 
bookKeeping;

%% modify here

titleDescript = 'Run1 and Run2 Contours FOV';
 
contourLevel = 0.9;

list_subInds = 1:20;

roiName = {
    'left_VWFA_rl'
    };

% --- THE UNDERLAY ------
% if underlayCoverage is false, the background on which the contours will
% be plotted will just be a solid color, which you specify in
% vfc.backgroundColor
underlayCoverage = true; 
underlay_dtName = {'Words'};
underlay_rmName = {'retModel-Words-css.mat'};

% -----------------------

% --- THE CONTOURS -------
%  'Words_scale1mu0sig1p5'
list_dtNames = {
    'Checkers'
    'Words'
    };
list_rmNames = {
    'retModel-Checkers-css.mat'
    'retModel-Words-css.mat'
    };
% ------------------------
list_rmColors = [
    [.15 .15 .15]
    [.15 .15 .15]
%     [.2 1 .2]; % Checkers
%     [.9 .2 .2]; % Words
    ];

% list_rmCenterColors = list_rmColors; 
list_rmCenterColors = [
    [.5 .5 .5]
    [.5 .5 .5]
    ];

list_rmMarkers = {
    '--'
    '--'
    };

% vfc for the underlay
underlay_vfc = ff_vfcDefault; 
underlay_vfc.addCenters = false; 

% vfc for the contours
vfc = ff_vfcDefault();
vfc.addCenters = true;  
vfc.contourLevel = contourLevel; 
vfc.nboot = 50;
vfc.backgroundColor = [1 1 1];
vfc.cmap = 'hot';

%% define things
numSubs = length(list_subInds);
numRms = length(list_rmNames);

%% make the rmroi cell

rmroiCell = ff_rmroiCell(list_subInds, roiName, list_dtNames, list_rmNames);

if underlayCoverage
    underlay_rmroiCell = ff_rmroiCell(list_subInds, roiName, underlay_dtName, underlay_rmName);
end

% assumption only do this for one roi for now
% jj = 1
jj = 1;

%% make the plot!
for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    subInitials = list_sub{subInd};
    
    % make the underlay polar plot
    if underlayCoverage
        
        figure;
        underlay_rmroi = underlay_rmroiCell{ii};
        rmPlotCoveragefromROImatfile(underlay_rmroi, vfc)
        h = gcf; 
        
    else
        figure; 
        ff_polarPlot(vfc);
        h = gcf;
    end

    for kk = 1:numRms
        
        % rmroi for the ret model
        rmroi = rmroiCell{ii,jj,kk};
        rmColor = list_rmColors(kk,:);
        rmMarker = list_rmMarkers{kk};
        rmCenterColor = list_rmCenterColors(kk,:);
        
        % add the contours from the individual ret models to the polar plot
        figure; 
        RFcov = rmPlotCoveragefromROImatfile(rmroi, vfc);
        close; 
        
        [contourMatrix, contourCoordsX, contourCoordsY] = ...
        ff_contourMatrix_makeFromMatrix(RFcov,vfc,vfc.contourLevel);

        % transform so that we can plot it on the polar plot
        contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
        contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
        
        figure(h)
        plot(contourX, contourY,rmMarker, 'Color', rmColor, 'MarkerSize', 4, 'LineWidth',2);
        axis image;   % axis square;
        xlim([-vfc.fieldRange vfc.fieldRange])
        ylim([-vfc.fieldRange vfc.fieldRange])
        
        % add the centers to the polar plot
        if vfc.addCenters
            figure(h)
            plot(rmroi.x0, rmroi.y0, '.', ...
                'Color', rmCenterColor, ...
                'MarkerSize', 3)
        end
    
    end
    
    titleName = {
        [titleDescript '. Level: ' num2str(contourLevel)]
        [ff_stringRemove(roiName{1}, '_rl'), '. ' subInitials]
        };
    title(titleName, 'Color', [.5 .5 .5]);
    
    figure(h)
    set(gcf, 'InvertHardcopy', 'off')
    
    ff_dropboxSave;
    close all; 
    
end