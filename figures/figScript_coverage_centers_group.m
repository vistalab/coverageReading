%% Reading circuitry field of view paper (2016). Making figures

% Uses this script: coverage_plotCenters.m

%% plots all the centers of an roi for all subjects
close all; clear all; clc;
bookKeeping;

%% modify here

% transparent? much much longer 
% with matlab2015, able to use scatter function
transparent = true; 

% alpha value -- transparency
alphaValue = .2; 

% subjects to include
list_subInds = 	[13:20]; %[1:20];

% threshold and other visualization parameters
vfc = ff_vfcDefault; 
vfc.backgroundColor = [.9 .9 .9]; 
vfc.gridColor = [.5 .5 .5];

% rois plotted individually or all on one plot
% if true, can specify many rois
% if false, specify the rois we want on a single coverage plot.
% list_colors will then correspond to rois
roisIndividual = false; 

% if true, colors will correspond to ROI
colorIndividual = true;

% rois to do this for
list_roiNames = {
%     'LV1_rl'
%     'cVOTRC'
%     'lVOTRC-threshBy-WordsAndCheckers-co0p2'
    'right_FFAFace_rl'
%     'rVOTRC'
%     'cVOTRC'
%     'lVOTRC-threshBy-Words_HebrewAndWords_English-co0p05.mat'
%     'lVOTRC-threshBy-WordsOrCheckers-co0p05.mat'
%     'lVOTRC-threshBy-Words_English-Model-co0p2.mat'
%     'ch_PPA_Place_rl'
%     'combined_VWFA_rl'
%     'lVOTRC-threshBy-WordAndCheckerModel-co0p2.mat'
%     'right_VWFA_rl'
%     'LV1_rl'
%     'RV1_rl'
%     'RV2v_rl'
%     'LV2v_rl'
    };

% modify this if ~roiIndividual
list_colors = {
    [.5 .4 1]
%     [.2 1 0] % green - right visual hemisphere
%     [0 .2 1] % blue - left visual hemisphere
    };

% modify this if roiIndividual
dotColor = [.7 .1 .5];

% ret model dt and name
dtName = {'FaceSmall'};
rmName = {'retModel-FaceSmall-css.mat'}; 

%% define things

% number of subjects
numSubs = length(list_subInds);

% multiple roi centers on a plot
if ~roisIndividual
    figure; hold on; 
end

%% get the data once
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, dtName, rmName);
  
%% do the plotting

% loop over rois
close all; 
for jj = 1:length(list_roiNames)
    
    % roiname
    roiName = list_roiNames{jj};

    % each roi is its own figure
    if roisIndividual
        figure; hold on;
    else
        dotColor = list_colors{jj};
    end

    % loop over subjects
    for ii = 1:numSubs
        
        if colorIndividual
            subInd = list_subInds(ii);
            dotColor = list_colorsPerSub(subInd,:);
        end
        
        rmroi = rmroiCell{ii,jj};   
        if isempty(rmroi)
            rmroithresh = []; 
        else
             rmroithresh = ff_thresholdRMData(rmroi, vfc);
        end
       

        % plot the centers if passes threshold
        if ~isempty(rmroithresh)
            if transparent
                % semi-transparent centers
                scatter(rmroithresh.x0, rmroithresh.y0, 60, ...
                    repmat(dotColor,[length(rmroithresh.x0), 1]), 'filled', ...
                    'markerEdgeColor', [.1 .1 .1], ...
                    'LineWidth',.05);
                alpha(alphaValue)
            else
                plot(rmroithresh.x0, rmroithresh.y0, 'o','Color', dotColor, ...
                    'MarkerSize', 10, 'MarkerFaceColor', dotColor)
            end

            % Limit plot to visual field circle and add polar plot
            axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange]);
            ff_polarPlot(vfc); 

        end % if thresholded rm passes value
    end % loop over subjects

    roiNameDescript = ff_stringRemove(roiName, '_rl');
    titleName = {
        'pRF Centers. ' 
        roiNameDescript 
        ['Stim: ' dtName{1}]
        };
    title(titleName, 'FontWeight', 'Bold', 'Color',[.5 .5 .5])

    
end % loop over rois


