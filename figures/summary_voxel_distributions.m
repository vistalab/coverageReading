%% compare 2 (IMPORTANT ASSUMPTION) distributions
% makes a subplot of size (2,1)
% flexible
% i.e. centers of the prfs of 2 ROIS
close all; clear all; clc; 
bookKeeping; 

%% modify here

% subject indices in the 2 groups. indicate each as a row vector
list_subInds_all = {
    [1:20];     % words
    [1:20];     % checkers
    };

% roi for each population
list_rois_all = {
    'lVOTRC' 
    'lVOTRC'
    };

% rm field for each population
list_rmFields_all = {
    'ecc'
    'ecc'
    };

% dts and rms
list_dts_all = {
    'Words'
    'Checkers'
    };
list_rms_all = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% how to threshold. assumes same for both
vfc = ff_vfcDefault; 

% number of bins. assume same for now
numBins = 20; 

% save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/summaries';
saveDropbox = true; 

%% 

Data = cell(2,1); 

% loop over the populations
for pp = 1:2
    
    % subInds, dt, and rm for this population
    list_subInds = list_subInds_all{pp};  
    dtName = list_dts_all{pp}; 
    rmName = list_rms_all{pp};
    rmField = list_rmFields_all{pp};
    roiName = list_rois_all{pp};
    data = []; 
    
    % loop over subjects in population
    for ii = list_subInds; 
        
        % initialize the gray and other basic info
        subInitials = list_sub{ii};
        dirAnatomy = list_anatomy{ii};
        dirVista = list_sessionRet{ii}; 
        chdir(dirVista); 
        vw = initHiddenGray; 
        
        % load the ret model
        rmPath = fullfile(dirVista, 'Gray', dtName , rmName);
        rmExists = exist(rmPath, 'file');
        
        % load the roi
        roiPath = fullfile(dirAnatomy,'ROIs', roiName);
        [vw, roiExists] = loadROI(vw, roiPath, [],[],1,0);
        
        if roiExists && rmExists
            vw = rmSelect(vw, 1, rmPath); 
            vw = rmLoadDefault(vw); 
            rm = rmGetParamsFromROI(vw); 
            rm.subInitials = subInitials; 
            rmthresh = ff_thresholdRMData(rm, vfc);
            
            % get the field we're interested and append
            tem = eval(['rmthresh.' rmField]);
            data = [data tem]; 
            
        end % if roi and rm exists
         
    end % loop over subjects in population
    
    % store population data
    Data{pp,1} = data; 
    
end % loop over populations


%% plot
close all; 
figure; 
ymax = nan(1,2);
xmax = nan(1,2);

for pp = 1:2
   
    % title names
    roiName = list_rois_all{pp};
    roiDescript = ff_stringRemove(roiName, '_rl');
    
    % bin the data. and normalize
    data = Data{pp}; 
    [counts, binCenters] = hist(data, numBins);
    numVoxels = sum(counts); 
    countsNorm = counts ./ numVoxels; 
    
    % plot
    subplot(2,1,pp)
    bar(binCenters, countsNorm)
    title([roiDescript '. voxel ' rmField ' distribution'])
    xlabel([rmField])
    ylabel('Normalized Counts')
    axis([0 15 0 .5])
    grid on
    
    % plot the median
    med = median(data);
    hold on
    plot([med med], [0 max(get(gca, 'YLim'))], 'color', 'r', 'LineWidth', 2)
    
    % record x and y limits so that both can have the same axis
    xmax(pp) = max(get(gca, 'Xlim'));
    ymax(pp) = max(get(gca, 'Ylim'));
    
end

%% save
ff_dropboxSave;
