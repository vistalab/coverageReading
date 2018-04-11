function rmroi = ff_rmroiMake(roiName, list_subInds, dtName, rmName)
error('outdated function ... USE ff_rmroiCell')

%% function that will make the rmroi struct for a given list of subjects
% rmroi = ff_rmroiMake(roiName, list_subInds, dtName, rmName)
% use ff_rmroiCell instead. more updated.
% this should be deleted ...


%% define and initialize some things
bookKeeping; 
numSubs = length(list_subInds);
rmroi = cell(1, numSubs); 

%% loop over subjects
for ii = 1:numSubs
    
    % subject index
    subInd = list_subInds(ii);
    
    % dirVista. move here and intialize the view
    dirVista = list_sessionPath{subInd};
    chdir(dirVista);
    vw = initHiddenGray;
    
    % subject anatomy directory
    dirAnatomy = list_anatomy{subInd};

    % load the roi
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    vw = loadROI(vw, roiPath, [], [], 1, 0);
    
    % load the ret model
    rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
    vw = rmSelect(vw, 1, rmPath); 
    vw = rmLoadDefault(vw);
    
    % get the rmroi struct
    r = rmGetParamsFromROI(vw); 
    
    rmroi{ii} = r;
    
end