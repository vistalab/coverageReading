%% 
% x axis: eccentricity bins (or prf size bins)
% y axis: percent of voxels

clear all; close all; clc; 
bookKeeping; 

%% modify here

% names of the roi
list_rois = {
    'rh_pFus_Face_rl';
    'lh_pFus_Face_rl';
    'lh_mFus_Face_rl';
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'LV2d_rl'
%     'LV3d_rl'
%     'LIPS0_rl'
%     'ch_VWFA_rl'
%     'rh_pFus_Face_rl'
%     'ch_PPA_Place_rl'
    }; 

% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% fieldToPlotDescript is for axis labels and plot titles
fieldToPlot         = 'sigma'; 
fieldToPlotDescript = 'pRF size'; 
numBins             = 10; 
fieldRange          = [0 15]; 
getRidOfLastBin     = true; 

% subjects to analyze (indices defined in bookKeeping.m)
% sometimes we only want to do a subset of the subjects, or only look at 1
list_subInds =  [1:4 6:12];


% list of data types to look at. Does this for every ROI
list_dtNames = {
    'Checkers';
    'Words'; 
    'FalseFont'; 
}; 

% names of the ret model in the corresponding dt
list_rmNames = {
    'retModel-Checkers.mat'
    'retModel-Words.mat'
    'retModel-FalseFont.mat'
    };

% which rms are we comparing? 
% we could be describing stim types
rmCompareDescript = 'Checkers Word FalseFont Comparison';

% colors corresponding to stim types
list_colors = {
    [0 1 .9];
    [1 0 .2];
    [.2 .9 .1];
%    [.6 .1 .6]
    };

% values to threshold the RM struct by
h.threshco = 0.1;
h.threshecc = [0 15];
h.threshsigma = [0 30];
h.minvoxelcount = 0;

% save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/histograms/';
saveExt = 'png';


%% initialize some info
 
% number of rois
numRois = length(list_rois);

% number of subjects to analyze
numSubs = length(list_subInds); 

% number of stimulus types
numDts = length(list_dtNames); 

% intialize things
% this is a numStims x numBins x  numSubs matrix
S = zeros(numDts, numBins, numSubs); 

% histogram information
[~, binCenters] = hist([fieldRange(1): fieldRange(2)],numBins);

%% get the information from all subjects, rois, and stim types

for jj = 1:numRois
    
    % roi name 
    roiName = list_rois{jj};
    
    %% loop over the subjects
    for ii = 1:numSubs
        
        % subject index
        subInd = list_subInds(ii);
        
        % subject's anatomy directory
        dirAnatomy = list_anatomy{subInd};
        
        % subject's ret path
        dirVista = list_sessionPath{subInd};
        chdir(dirVista);
        
        % roi path
        roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']);
        
        % open the view
        vw = initHiddenGray; 
        
        % if roi exists, load the roi, then do for multiple datatypes        
        if exist(roiPath, 'file')
            
            vw = loadROI(vw, roiPath, [], [], 1, 0);

            %% loop the datatypes
            for kk = 1:numDts

                % this datatype and rmname
                dtName = list_dtNames{kk};
                rmName = list_rmNames{kk};

                % set the current dt
                vw = viewSet(vw, 'curdt', dtName);

                % path of the ret model
                pathRm = fullfile(dirVista, 'Gray', dtName, rmName);

                % load the ret model
                vw = rmSelect(vw, 1, pathRm);
                vw = rmLoadDefault(vw);

                % get the rmroi struct
                rmroi = rmGetParamsFromROI(vw);

                % get the thresholded rmroi struct
                rmroi_thresh = ff_thresholdRMData(rmroi,h);

                if ~isempty(rmroi)
                    g =  eval(['rmroi.' fieldToPlot]); 

                    % bin this information. Get the percentage of voxels
                    numInBin        = hist(g, binCenters); 
                    numInBinPercent = numInBin./sum(numInBin); 

                    % store it
                    % S is a numStims x numBins x  numSubs matrix
                    S(kk,:,ii) = numInBinPercent; 
                end


            end
        end
    end
    
    
    
    
    %% plot ----------------------------------------------
    figure(); 
    hold on; 

    for kk = 1:numDts

        % color
        thisColor = list_colors{kk}; 

        % mean across subjects
        meanVal = mean(S(kk, :,:),3); 

        % standard error across subjects
        steVal = sqrt(var(S(kk, :,:),[],3)./numSubs); 

        % plotting. 
        % get rid of the last bin if so desired
        if getRidOfLastBin            
            theCenters = binCenters(1:end-1);
            theMeans = meanVal(1:end-1); 
            theStes = steVal(1:end-1);         
        else
            theCenters = binCenters;
            theMeans = meanVal; 
            theStes = steVal;            
        end
        
         errorbar(theCenters, theMeans, theStes, '.-', ...
            'Color', thisColor ,... 
            'LineWidth', 2, ...
            'MarkerSize', 40, ...
            'MarkerEdgeColor', list_colors{kk});
        
        xlabel(fieldToPlotDescript)
        ylabel('Percent of Voxels')

    end

    % titleName = [roiName(1:(end-3)) '.' fieldToPlotDescript ' Bins'];
    titleName = [roiName '.' fieldToPlotDescript ' Bins. ' rmCompareDescript];
    title(titleName); 
    legend(list_rmNames);
    grid on; 
    hold off; 

    % save
    saveas(gcf, fullfile(saveDir, [titleName '.' saveExt]), saveExt); 
    saveas(gcf, fullfile(saveDir, [titleName '.fig' ]), 'fig'); 



end

