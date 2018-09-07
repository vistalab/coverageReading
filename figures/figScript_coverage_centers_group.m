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
alphaValue = 1; 

% subjects to include
% %[31:36 38 39:44] % Hebrew
list_subInds = 	1:12; %[1:20];

% threshold and other visualization parameters
vfc = ff_vfcDefault; 
vfc.backgroundColor = [1 1 1]; % [.9 .9 .9]; 
vfc.gridColor = [.5 .5 .5];

% rois plotted individually or all on one plot
% if true, can specify many rois
% if false, specify the rois we want on a single coverage plot.
% list_colors will then correspond to rois
roisIndividual = false; 

% rois to do this for
list_roiNames = {
%     'LV1_rl'
%     'lVOTRC'
%     'LV2v_rl'
    'lVOTRC-threshBy-WordsAndCheckers-co0p2'
%     'right_FFAFace_rl'
%     'rVOTRC'
%     'cVOTRC'
%     'lVOTRC'
%     'lVOTRC-threshBy-Words_HebrewAndWords_English-co0p2.mat'
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


% whether each subject is a different color
colorIndividual = true; 

% pRF center color. if we want every subject to have same color
centerColor = [1 0 0];

% ret model dt and name
dtName = {'FalseFont'};
rmName = {'retModel-FalseFont-css.mat'}; 

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
    end

    % loop over subjects
    for ii = 1:numSubs
        
        if colorIndividual
            subInd = list_subInds(ii);
            dotColor = list_colorsPerSub(subInd,:);
        else
            dotColor = centerColor; 
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
                dotSize = 60; %60 
                scatter(rmroithresh.x0, rmroithresh.y0, dotSize, ...
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


