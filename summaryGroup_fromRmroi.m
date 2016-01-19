%% group summary from rmroi structs
% each roi will be a color
%
% assumes the rmrois are named like this:
% <roiName>-<retModelName> where retModelName is everything without the "retModel-"

clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects
list_subInds = [13:19]; 

% session list
list_path = list_sessionRet; 

% what rm variable to plot. Options:
% co, sigma, ecc
rmField = 'sigma'; 
rmFieldDescript = 'size'; % plot titles

% statistic to compute for each subject
subStatFunction = @median; 
subStatDescript = 'median';

% individual voxels as small dots - indicate for each roi
list_individualVoxels = {
    false;
    false; 
    true; 
    true;
    false;
    false;
    false;
    false;
    false;
    false;
    };

% marker size of individual voxels
markerSizeIndividual = 2; 
% marker shape of individual voxels
markerShapeIndividual = 'o';
% marker size of the summary stat
markerSize = 12; 

% axis font size, includes legend (not title)
axisFontSize = 16; 


% thresholding the ret model --------------------------------------------
h.threshecc = [0 15]; 
h.threshco = 0;
h.threshsigma = [0 15]; 
h.minvoxelcount = 1; 

% list colors. correspond to rois
list_colors = {
    [.9 .9 .9]; % grayish
    [.8 .8 .8]; % grayish
    
%     [.9 .3 .3]; % reddish
%     [.7  .4 .1]; % reddish
    [.2 .9 .6]; % greenish
    [.2 .7 .2]; % greenish
    [.6 .3 .9]; % purplish
    [.4 .1 .9]; % purplish
    [.2 .2 .8]; % bluish
    [.3 .2 .9]; % bluish
    };

% construct rmroi names out of the following parameters ------------------
% rois we are interested in .
list_roiNames = {
%     'LV1_rl'
%     'RV1_rl'

%     'LIPS0_rl'
%     'RIPS0_rl'
    
    'left_VWFA_rl'
    'right_VWFA_rl'
%     'LV2d_rl'
%     'RV2d_rl'
%     'LV3d_rl'
%     'RV3d_rl'
%     'LV3ab_rl'
%     'RV3ab_rl'
%     'LIPS0_rl'
%     'RIPS0_rl'
    
%     'LV1_rl'
%     'RV1_rl'
%     'left_VWFA_rl'
%     'right_VWFA_rl'
%     'LIPS0_rl'
%     'RIPS0_rl'
    };

% ret model on x axis. WITHOUT the "retModel-"
rmNameX = 'WordLarge-css.mat';

% ret model on  y axis
rmNameY = 'WordSmall-css.mat';

% -----------------------------------------------------------------------

% list of shapes. corresponds to rm type
% options: + o * . x s d ^ v > < p h 
list_shapes = {
%     '+'
%     'o'
%     '.'
%     'x'
%     's'
%     'd'
%     '^'
%     'v'
%     '>'
%     '<'
%     'p'
%     'h'
    };

% path with the rmroi struct
rmroiPath = '/sni-storage/wandell/data/reading_prf/forAnalysis/rmrois';

% where to save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/summaries';

% save to dropbox?
saveDropbox = true; 

%% define things

% number of rois
numRois = length(list_roiNames); 

% description of comparison. plotting and saving purposes
% 'WordsCSS vs CheckersCSS'
temY = ff_stringRemove(rmNameY, '.mat');
temX = ff_stringRemove(rmNameX, '.mat');
comparisonDescript = [temY ' vs ' temX];


%% get the data

% loop through rois
for jj = 1:numRois
    
    % roiName and color (for plotting)
    roiName = list_roiNames{jj}; 
    roiColor = list_colors{jj};
    
    % rmroi struct names and paths. x and y axis
    rmroiNameX = [roiName '-' rmNameX]; 
    rmroiNameY = [roiName '-' rmNameY];
    rmroiPathX = fullfile(rmroiPath, rmroiNameX); 
    rmroiPathY = fullfile(rmroiPath, rmroiNameY); 
    
    % load the rmrois
    rmroiX = load(rmroiPathX); rmroiX = rmroiX.rmroi; 
    rmroiY = load(rmroiPathY); rmroiY = rmroiY.rmroi; 
    
    % remove empty elements of the rmrois
    % ideally wouldn't need this step
    rmroiX = rmroiX(~cellfun(@isempty, rmroiX)); 
    rmroiY = rmroiY(~cellfun(@isempty, rmroiY)); 
   
    % keeping track of when we start a new roi for plot legend purposes
    newRoi = true; 
    
    % will we be plotting individual voxels
    individualVoxels = list_individualVoxels{jj}; 
    
    counter = 0; 
    
    %% loop over subjects
    for ii = list_subInds
        
        % subject initials
        subInitials = list_sub{ii};

        % get the rmroi data for the subject
        [dataX, xExists] = ff_rmroiForSubject(rmroiX, subInitials); 
        [dataY, yExists] = ff_rmroiForSubject(rmroiY, subInitials); 
        
        if xExists && yExists
            
            % threshold rm data. x and y axis
            rx = ff_thresholdRMData(dataX, h); 
            ry = ff_thresholdRMData(dataY, h); 

            % if thresholded data are both not empty
            if (~isempty(rx) && ~isempty(ry))
                
                counter = counter + 1; 

                rxField = eval(['rx.' rmField]); 
                ryField = eval(['ry.' rmField]);

                x = subStatFunction(rxField);
                y = subStatFunction(ryField);

                % display for debugging
                display([roiName ' ' rx.subInitials])
                x,y
                
                % store so that we can plot OVER the individual voxels
                X(counter) = x; 
                Y(counter) = y; 
                
                % plotting individual subject means
                p = plot(x,y, 'o','MarkerFaceColor', roiColor,'MarkerSize', markerSize, ...
                    'MarkerEdgeColor', 'k'); 
                hold on

                if individualVoxels
                    % when doing pairwise comparisons of rm models that are
                    % thresholded, need to make sure we are plotting the same
                    % voxels
                    [rmxField, rmyField] = ff_rmFieldForPairwiseThresh(rx, ry, rmField); 
                    plot(rmxField, rmyField, markerShapeIndividual,'MarkerFaceColor', roiColor, ...
                        'MarkerEdgeColor', 'none','MarkerSize', markerSizeIndividual);  
                    hold on
                end % if we are plotting individual voxels
                
                % save plot data for legend if we started a new roi
                if newRoi
                    hLegend(jj) = p; 
                    % if we get here we don't have to keep saving plot handles
                    newRoi = false; 
                end

            end % checking that both thresholded data are not empty
            
        end % check that subject has (unthresholded) rmroi data

    end % loop over subjects
    
    SubStatX{jj} = X;
    SubStatY{jj} = Y; 
    
end % looping over rois

%% replot the subject summaries
% when we plot individual voxels, it tends to draw over the subject
% summaries. we redraw them, it does not take too long
for jj = 1:numRois

    % roicolor
    roiColor = list_colors{jj}; 
    
    % number of subjects with this ROI
    numSubs = length(X(:,jj)); 

    % x and y data
    vecX = SubStatX{jj}; 
    vecY = SubStatY{jj}; 
    
    p = plot(vecX,vecY, 'o','MarkerFaceColor', roiColor,'MarkerSize', markerSize, ...
        'MarkerEdgeColor', 'k');
    
end


%% naming conventions, bookKeeping things

% take out the _rl for all the roiNames - so that legend can look nicer
list_roiNamesNice = cell(size(list_roiNames)); 

for jj = 1:numRois
    
    % original roi name
    roiName = list_roiNames{jj}; 
    
    list_roiNamesNice{jj} = ff_stringRemove(roiName,  '_rl'); 
    
end

%% plotting properties
axis square; 
grid on; 
identityLine; 

% legend
L = legend(hLegend, list_roiNamesNice); 
set(L,'location','northwest')
set(L, 'FontSize', axisFontSize)

% axes labels
xlabel(rmNameX)
ylabel(rmNameY)

% axes font size
set(gca, 'FontSize', axisFontSize); 

% title
titleName = ['All Subjects Summary. ' subStatDescript ' ' rmFieldDescript '. ' comparisonDescript];
title(titleName, 'FontWeight', 'Bold')

%% save
% where to save depending on how we threshold

% name of the thresholded folder
dirThresh = ff_stringDirNameFromThresh(h); 

% does it exist? make it if no
dirThreshExists = exist(fullfile(saveDir, dirThresh), 'dir'); 
if ~dirThreshExists
    chdir(saveDir)
    mkdir(dirThresh)
end


savePath = fullfile(saveDir, dirThresh, titleName);
saveas(gcf, [savePath '.png'],'png')
saveas(gcf, [savePath '.fig'],'fig')

if saveDropbox
    saveDirDropbox = '/home/rkimle/Dropbox/TRANSFERIMAGES';
    saveas(gcf, fullfile(saveDirDropbox, [titleName '.png']), 'png');
    saveas(gcf, fullfile(saveDirDropbox, [titleName '.fig']), 'fig');
end

chdir('/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/summaries')