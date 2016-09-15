%% Reading circuitry field of view paper (2016). Making figures
% Uses this script:  summaryBootstrap_visFieldPreference.m

%% bootstrapped summary: visual field biases
% will sample with replacement the population size nbootstrap times and
% calculate the populations statistic

clear all; close all; clc; 
bookKeeping; 

%% modify here

% number of bootstrap steps
nbootstrap = 500; 

% subject indices in the 2 groups. indicate each as a row vector
list_subInds_all = {
    [1:15 17:21]
%     [1:11]
%     [13:19]
    };

% roi for each population
list_rois = {    
    'LV2v_rl'
    };

% dts and rms
list_dts_all = {
    'Words'
    };

list_rms_all = {
    'retModel-Words-css.mat'
    };

% session list
list_sessions_all = {
    list_sessionRet;
    };

% contour level
contourLevel = 0.6; 

% threshold
h.threshco = 0.2;
h.threshecc = [0 15];
h.threshsigma = [0 15];
h.minvoxelcount = 1; 

% number of bins
numBins = 8; 

% save
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/summaries';
saveDropbox = true; 

%% define things

% number of subplots
numPopulations = length(list_subInds_all);

% initalize
Data = cell(1, numPopulations); 

% vfc params
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                                            
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = h.threshco;         
vfc.eccthresh       = h.threshecc; 
vfc.nSamples        = 128;            
vfc.meanThresh      = 0;
vfc.weight          = 'varexp';  
vfc.weightBeta      = false;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;
vfc.nboot           = 50; 

%% do things
for pp = 1:numPopulations
    
    % roi, dt, rm, and subInds for the population
    roiName = list_rois{pp};
    dtName = list_dts_all{pp};
    rmName = list_rms_all{pp};
    
    list_subInds = list_subInds_all{pp};
    list_path = list_sessions_all{pp};
    numSubs = length(list_subInds); 
    data = nan(numSubs, 4); 
   
    %% calculate all the subjects once and store in a vector so we can just
    % pull from it.
    for ii = 1:numSubs
        subInd = list_subInds(ii); 
        subInitials = list_sub{subInd}; 
        
        dirAnatomy = list_anatomy{subInd};
        dirVista = list_path{subInd};
        chdir(dirVista);
        vw = initHiddenGray; 
        
        % load roi 
        roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
        [vw, roiExists] = loadROI(vw, roiPath, [],[],1,0);
        
        % rm path
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
        rmExists = exist(rmPath, 'file');
        
        if rmExists && roiExists
            vw = rmSelect(vw, 1, rmPath);
            rm = rmGetParamsFromROI(vw);  
            rm.subInitials = subInitials; 
            %  rmthresh = ff_thresholdRMData(rm, h);
            rmthresh = rm; % ff_thresholdRMData doing something funky
            
            % plot the coverage
            %  [RFcov, ~, ~, ~, ~] = ff_rmPlotCoveragefromROImatfile(rmthresh,vfc,vw); 
            [RFcov, ~, ~, ~, ~] = rmPlotCoveragefromROImatfile(rmthresh,vfc); 
            
            % RFcov is flipud from what is plotted
            % RFcovflip = flipud(RFcov);
            RFcovflip = RFcov; 
            
            % area in each hemifield
            [left, right, up, down] = ff_coverageArea_hemifields(contourLevel, vfc, RFcovflip); 
            data(ii,:) = [left, right, up, down];
            
        end % if roi and rm exists

    end % end looping over subjects in the population
    
    % store
    Data{pp} = data;
       
end % loop over populations

%% bootstrapping
% [left, right, up, down]
B = cell(1, numPopulations);

for pp = 1:numPopulations
    
    % population data
    data = Data{pp}; 
    
    % bootstat returns nboot x 4 matrix with the median
    bootstat = bootstrp(nbootstrap,@mean,data);
    B{pp} = bootstat; 
    
end

close all; 

%% plot: left vs. right comparison
 
figure; 
ymax = nan(1,numPopulations);
xmin = nan(1,numPopulations);
xmax = nan(1,numPopulations);
sh = nan(1, numPopulations);

for pp = 1:numPopulations
    
    % roiName
    roiName = list_rois{pp};
    roiDescript = ff_stringRemove(roiName, '_rl');
    
    % population's left and right
    bootstat = B{pp}; 
    Left = bootstat(:,1); 
    Right = bootstat(:,2);
    Diff = Right - Left; 
    
    sh(pp) = subplot(numPopulations, 1, pp);
    [counts, binCenters] = hist(Diff, numBins);
    countsNorm = counts/sum(counts); 
    bar(binCenters, countsNorm)
    grid on    
    title({'Right Visual Field Area - Left Visual Field Area', roiDescript}, 'FontWeight', 'Bold')
    xlabel('Coverage area difference (vis ang deg^2)')
    ylabel('Normalized Counts')
    
    % add the median
    med = median(Diff);
    hold on; 
    plot([med med], [0 1], 'LineWidth', 2, 'color', 'r')
    
    % axes limit data
    ymax(pp) = max(get(gca, 'YLim')); 
    xmin(pp) = min(get(gca, 'Xlim'));
    xmax(pp) = max(get(gca, 'Xlim'));
    
end

% make axes comparable
Xmax = max(xmax);
Xmin = min(xmin);
Ymax = max(ymax);

for pp = 1:numPopulations
    
    % make the subplot current
    subplot(sh(pp));
    set(gca, 'Xlim', [Xmin Xmax]);
    set(gca, 'YLim', [0 Ymax]);
    
end


% dropbox save
save_figureToDropbox;


%% plot: up - down comparison
figure; 
ymax = nan(1,numPopulations);
xmin = nan(1,numPopulations);
xmax = nan(1,numPopulations);
sh = nan(1, numPopulations);

for pp = 1:numPopulations
    
    % roiName
    roiName = list_rois{pp};
    roiDescript = ff_stringRemove(roiName, '_rl');
    
    % population's left and right
    bootstat = B{pp}; 
    Up = bootstat(:,3); 
    Down = bootstat(:,4);
    Diff = Up - Down; 
    
    sh(pp) = subplot(numPopulations, 1, pp);
    [counts, binCenters] = hist(Diff, numBins);
    countsNorm = counts / sum(counts); 
    bar(binCenters, countsNorm)
    grid on
    
    % add the median
    med = median(Diff);
    hold on; 
    plot([med med], [0 1], 'LineWidth', 2, 'color', 'r')
       
    title({'Upper Visual Field Area - Lower Visual Field Area', roiDescript}, 'FontWeight', 'Bold')
    xlabel('Coverage area difference (vis ang deg^2)')
    ylabel('Normalized Counts')
    
    % axes limit data
    ymax(pp) = max(get(gca, 'YLim')); 
    xmin(pp) = min(get(gca, 'Xlim'));
    xmax(pp) = max(get(gca, 'Xlim'));
    
end

% make axes comparable
Xmax = max(xmax);
Xmin = min(xmin);
Ymax = max(ymax);

for pp = 1:numPopulations
    
    % make the subplot current
    subplot(sh(pp));
    set(gca, 'Xlim', [Xmin Xmax]);
    set(gca, 'YLim', [0 Ymax]);
    
end

% dropbox save
save_figureToDropbox;