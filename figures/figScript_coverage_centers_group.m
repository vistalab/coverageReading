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
alphaValue = 0.5; 

% subjects to include
list_subInds = 1:20 %[1:20];

% session list
list_path = list_sessionRet; 

% rois plotted individually or all on one plot
% if true, can specify many rois
% if false, specify the rois we want on a single coverage plot.
% list_colors will then correspond to rois
roisIndividual = true; 

% if true, colors will correspond to ROI
colorIndividual = true;

% rois to do this for
list_rois = {
%     'ch_PPA_Place_rl'
%      'combined_VWFA_rl'
    'left_VWFA_rl'
    'right_VWFA_rl'
%      'LV1_rl'
%      'RV1_rl'
%     'RV2v_rl'
%     'LV2v_rl'

    };

% modify this if ~roiIndividual
list_colors = {
    [1 1 1]
%     [.2 1 0] % green - right visual hemisphere
%     [0 .2 1] % blue - left visual hemisphere
    };
% modify this if roiIndividual
dotColor = [1 1 1];

% ret model dt and name
dtName = 'Checkers';
rmName = 'retModel-Checkers-css.mat'; 

% threshold and other visualization parameters
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
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;
vfc.backgroundColor = [.1 .1 .1];   % color
vfc.fillColor       = [1 0 0];   % yet to figure out what this does
vfc.color           = [0 1 0];   % yet to figure out what this does
vfc.tickLabel       = false; 



% save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/centers';
saveDropbox = true; 

%% define things

% number of subjects
numSubs = length(list_subInds);

% threshold string (saving purposes)
h.threshecc = vfc.eccthresh;
h.threshco = vfc.cothresh; 
h.threshsigma = [0 30]; % actually not taken into account, so just indicate the max
h.minvoxelcount = 1;

% multiple roi centers on a plot
if ~roisIndividual
    figure; hold on; 
end

% loop over rois
for jj = 1:length(list_rois)
    
    % roiname
    roiName = list_rois{jj};

    % each roi is its own figure
    if roisIndividual
        figure; hold on;
    else
        dotColor = list_colors{jj};
    end

    % loop over subjects
    for ii = 1:numSubs

        % subject
        subInd = list_subInds(ii);
        subInitials = list_sub{subInd};
        dirVista = list_path{subInd};
        dirAnatomy = list_anatomy{subInd};
        chdir(dirVista);
        vw = initHiddenGray; 
        
        if colorIndividual
            dotColor = list_colorsPerSub(subInd,:);
        end

        % load the roi
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
        [vw, roiExists] = loadROI(vw, roiPath, [],[],1,0);

        % rmpath
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
        rmExists = exist(rmPath, 'file');

        % do things if both rm and roi exists
        if rmExists && roiExists

            vw = rmSelect(vw, 1, rmPath);
            vw = rmLoadDefault(vw);
            rmroi = rmGetParamsFromROI(vw);
            rmroi.subInitials = subInitials; 

            % threshold
            rmroithresh = ff_thresholdRMData(rmroi, vfc);

            % plot the centers if passes threshold
            if ~isempty(rmroithresh)
                
                if transparent
                    % semi-transparent centers
                    ff_scatter_patches(rmroithresh.x0, rmroithresh.y0, 3, dotColor, 'FaceAlpha', alphaValue, 'EdgeColor', 'none');
                else
                    plot(rmroithresh.x0, rmroithresh.y0, '.','Color', dotColor, 'MarkerSize', 8)
                end
                
                
                % Limit plot to visual field circle
                axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])

                % polar plot
                ff_polarPlot(vfc); 
                
            end % if thresholded rm passes value

        end % if both rm and roi exists

    end % loop over subjects


    %% title and other plot properties
    if roisIndividual
        roiNameDescript = ff_stringRemove(roiName, '_rl');
        titleName = ['pRF Centers. ' roiNameDescript '. Stim ' dtName];
        title(titleName, 'FontWeight', 'Bold')


        %% save
        
         % save as the same color as printed to screen
         set(gcf, 'inverthardcopy', 'off') % save as the same color as printed to screen
        
        threshDir = ff_stringDirNameFromThresh(h);
        if ~exist(fullfile(saveDir, threshDir), 'dir')
            mkdir(fullfile(saveDir, threshDir), 'dir')
        end

        savePath = fullfile(saveDir, threshDir);
        saveas(gcf, fullfile(savePath, [titleName '.png']), 'png')
        saveas(gcf, fullfile(savePath, [titleName '.fig']), 'fig')

        if saveDropbox, ff_dropboxSave, end
             
    end % save individual roi figures
    
end % loop over rois

%% save after all rois are plotted if so desired
if ~roisIndividual
    
    roiNameDescript =  ff_cellstring2string(list_rois);
    titleName = ['pRF Centers. ' roiNameDescript '. Stim ' dtName];
    title(titleName, 'FontWeight', 'Bold')


    %% save
    
    set(gcf, 'inverthardcopy', 'off') % save as the same color as printed to screen
    
    threshDir = ff_stringDirNameFromThresh(h);
    if ~exist(fullfile(saveDir, threshDir), 'dir')
        mkdir(fullfile(saveDir, threshDir), 'dir')
    end

    savePath = fullfile(saveDir, threshDir);
    saveas(gcf, fullfile(savePath, [titleName '.png']), 'png')
    saveas(gcf, fullfile(savePath, [titleName '.fig']), 'fig')

    if saveDropbox, ff_dropboxSave, end
    
end

