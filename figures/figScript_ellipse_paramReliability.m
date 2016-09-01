%% scatter plot of run 1 and run2 -- ellipse reliability
close all; clear all; clc; 
bookKeeping;

%% modify here

vfc = ff_vfcDefault;
vfc.cmap = 'hot'; 
vfc.addCenters = true; 
contourLevel = 0.5; 

list_subInds = 1:20; 
roiName = {'left_VWFA_rl'};

% will be lots of hard coded assumptions here ...
% Words -- underlay for plotting graph
% Words1 -- for reliability
% Words2 -- for reliability

list_dtNames = {
    'Words'
    'Words1'
    'Words2'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Words1-css.mat'
    'retModel-Words2-css.mat'
    };

%% get the rmroi cell
rmroiCell = ff_rmroiCell(list_subInds, roiName, list_dtNames, list_rmNames);


%% initialize things
numSubs = length(list_subInds);
ellipseCell = cell(numSubs,2); 
ellipseA = zeros(numSubs, 2);
ellipseB = zeros(numSubs, 2);

%% calculate reliability for each subject

for ii = 1:numSubs
    
    subInd = list_subInds(ii);
    subInitials = list_sub{subInd};
    
    %% rmroi for the underlay
    rmroi_under = rmroiCell{ii,1,1}; 
    rmPlotCoveragefromROImatfile(rmroi_under, vfc); 
    fh = gcf; 
    
    %% ellipse param run 1
    % TODO functionalize some things
    rmroi_ind1 = rmroiCell{ii,1,2};
    
    % get the rfcov to plot ellipse
    rfcov = rmPlotCoveragefromROImatfile(rmroi_ind1, vfc); 
    
    % sometimes no voxels pass threshold ....
    if sum(rfcov(:) ~= 0)
        % get the contour so that we can fit the ellipse
        [contourMatrix, contourCoordsX, contourCoordsY] = ...
            ff_contourMatrix_makeFromMatrix(rfcov,vfc,contourLevel);

        % transform so that we can get the fit in units of visual angle degrees
        contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
        contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 

        % plot the ellipse
        figure(fh); 
        ellipse_t = ff_fit_ellipse(contourX, contourY,gca); 

        % save ellipse params
        ellipseCell{ii,1} = ellipse_t; 
        ellipseA(ii,1) = ellipse_t.a; 
    end
      

    %% ellipse param run 2
    rmroi_ind2 = rmroiCell{ii,1,3};
    
    % get the rfcov to plot ellipse
    rfcov = rmPlotCoveragefromROImatfile(rmroi_ind2, vfc); 
    
    if sum(rfcov(:) ~= 0)
        % get the contour so that we can fit the ellipse
        [contourMatrix, contourCoordsX, contourCoordsY] = ...
            ff_contourMatrix_makeFromMatrix(rfcov,vfc,contourLevel);

        % transform so that we can get the fit in units of visual angle degrees
        contourX = contourCoordsX/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 
        contourY = contourCoordsY/vfc.nSamples*(2*vfc.fieldRange) - vfc.fieldRange; 

        % plot the ellipse
        figure(fh); 
        ellipse_t = ff_fit_ellipse(contourX, contourY,gca); 

        % save ellipse params
        ellipseCell{ii,2} = ellipse_t; 
        ellipseA(ii,2) = ellipse_t.a; 
    end
    
    %% save
    titleName = {
        ['FOV with independent fitted ellipses']
        [roiName{1} '. ' subInitials '. ' list_dtNames{1}]
        [mfilename]
        };
    title(titleName, 'fontweight', 'bold')
    ff_dropboxSave; 
    
    close all; 
   
end

%% plot scatter
figure; 
plot(ellipseA(:,1), ellipseA(:,2), 'o', ...
    'MarkerFaceColor', [0 .5 .7], 'MarkerEdgeColor', [0 0 0], ...
    'MarkerSize', 12, 'LineWidth', 2);

grid on; 
ff_identityLine(gca, [.5 .5 .5]); 

% axes labels
xlabel('Run 1 Radius A (deg)'); 
ylabel('Run 2 Radius A (deg)'); 


% title and save
titleName = ['Ellipse A radius reliability. ' roiName{1} ' ' list_dtNames{1}];
title(titleName, 'fontweight', 'bold')

ff_dropboxSave; 