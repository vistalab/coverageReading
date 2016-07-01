%% individual summary from rmroi structs
% each roi will be a color
%
% assumes the rmrois are named like this:
% <roiName>-<retModelName> where retModelName is everything without the "retModel-"

clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects to do this for
list_subInds = [1:4 6:19]; 

% session list
list_path = list_sessionRet; 

% what rm variable to plot. Options:
% co, sigma, ecc
rmField = 'sigma'; 
rmFieldDescript = 'size'; % plot titles

% statistic to compute for each subject
subStatFunction = @median; 
subStatDescript = 'median';

% thresholding the ret model --------------------------------------------
h.threshecc = [0 15]; 
h.threshco = 0.2;
h.threshsigma = [0 15]; 
h.minvoxelcount = 0; 

% list colors. correspond to rois
list_colors = {
    [.9 .3 .3];
    [.7  .4 .1];
    [.2 .9 .6];
    [.2 .7 .2];
%     [.6 .3 .9];
%     [.4 .1 .9];
    };

% construct rmroi names out of the following parameters ------------------
% rois we are interested in .
list_roiNames = {
    'LV1_rl'
    'RV1_rl'
    'left_VWFA_rl'
    'right_VWFA_rl'
%     'LIPS0_rl'
%     'RIPS0_rl'
    };

% ret model on x axis. WITHOUT the "retModel-"
rmNameX = 'Checkers-css.mat';

% ret model on  y axis
rmNameY = 'Words-css.mat';

% description of comparison. plotting and saving purposes
% 'WordsCSS vs CheckersCSS'
comparisonDescript = 'WordsCSS vs CheckerCSS';

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
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/summaries';

%% define things

% number of rois
numRois = length(list_roiNames); 

% take out the _rl for all the roiNames - so that legend can look nicer
list_roiNamesNice = cell(size(list_roiNames)); 

for jj = 1:numRois
    
    % original roi name
    roiName = list_roiNames{jj};     
    list_roiNamesNice{jj} = ff_stringRemove(roiName,  '_rl'); 
    
end

%% get the data

% loop over subjects
for ii = list_subInds

    % subject initials
    subInitials = list_sub{ii};

    % loop over rois
    for jj = 1:numRois

        % keeping track of when we start a new roi for plot legend purposes
        newRoi = true; 
        
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

        % get the rmroi data for the subject
        [dataX, xExists] = ff_rmroiForSubject(rmroiX, subInitials); 
        [dataY, yExists] = ff_rmroiForSubject(rmroiY, subInitials); 

        if xExists && yExists

            % threshold rm data. x and y axis
            rx = ff_thresholdRMData(dataX, h); 
            ry = ff_thresholdRMData(dataY, h); 

            % if thresholded data are both not empty
            if (~isempty(rx) && ~isempty(ry))

                rxField = eval(['rx.' rmField]); 
                ryField = eval(['ry.' rmField]);

                % summary  statistic. 
                xStat = subStatFunction(rxField);
                yStat = subStatFunction(ryField);

                % display for debugging
                display([roiName ' ' rx.subInitials])
                xStat,yStat

                % plotting subject summary statistic
                p = plot(xStat,yStat, 'o','MarkerFaceColor', roiColor, 'MarkerSize', 5); 
                hold on

                % plot all the voxels
                % when doing pairwise comparisons of rm models that are
                % thresholded, need to make sure we are plotting the same
                % voxels
                [rmxField, rmyField] = ff_rmFieldForPairwiseThresh(rx, ry, rmField); 
                plot(rmxField, rmyField, '.','Color', roiColor, 'MarkerSize', 2);

                % save plot data for legend if we started a new roi
                if newRoi
                    hLegend(jj) = p; 
                    % if we get here we don't have to keep saving plot handles
                    newRoi = false; 
                end

            end % checking that both thresholded data are not empty

        end % check that subject has (unthresholded) rmroi data

    end % loop over rois
        
    %% plotting properties
    axis square; 
    grid on; 
    identityLine; 

    % legend
    L = legend(hLegend, list_roiNamesNice); 
    set(L,'location','northwest')

    % axes labels
    xlabel(rmNameX)
    ylabel(rmNameY)

    % title
    titleName = ['Individual Summary. ' subInitials '. ' subStatDescript ' ' rmFieldDescript '. ' comparisonDescript];
    title(titleName, 'FontWeight', 'Bold')

    %% save

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

    close all; 



end % loop over subjects








