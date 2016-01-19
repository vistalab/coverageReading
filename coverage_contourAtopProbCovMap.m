%% individual {contourLevel} outline on top of a probabilistic map
% this script name is probably not the most descriptive right now
% TODO rename

clear all; close all; clc; 
bookKeeping; 


%% modify here

% subjects to do this for
list_subInds = 17%[1:11 13:23]; 
% session list
list_path = list_sessionRet; 

% ret model and roi. will derive probMap from these parameters
roiName = 'LV2v_rl';
dtName = 'Words';
rmName = 'retModel-Words-css.mat'; 
contourLevel = 0.9; 
probMapDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/data/probMapCoverage';

% vfc parameters
vfc.prf_size        = true; 
vfc.fieldRange      = 15;
vfc.method          = 'max';         
vfc.newfig          = true;                      
vfc.nboot           = 50;                        
vfc.normalizeRange  = true;              
vfc.smoothSigma     = true;                
vfc.cothresh        = 0.1;         
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

% SAVE
dropboxSave = true; 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/coverageProbMap'; 


%% define things here so we don't have to keep changing it
if strcmp(dtName, 'Checkers')
    contourColor = list_colors{1};
elseif strcmp(dtName, 'Words')
    contourColor = list_colors{2};
elseif strcmp(dtName, 'FalseFont')
    contourColor = list_colors{3};
else % define one's own color
    contourColor = [.2 .8 .6];
end


%% load the probMap
if ~isempty(strfind(rmName, 'css'))
    modelType = 'css';
end
probMapName = ff_probMapName(roiName, dtName, modelType, contourLevel);
probMapPath = fullfile(probMapDir, [probMapName '.mat']);
load(probMapPath); % probMap
probMap = flipud(probMap);


%% loop over subjects
for ii = list_subInds
    
    % dirVista
    dirVista = list_sessionRet{ii};
    chdir(dirVista);
    vw = initHiddenGray; 
    subInitials = list_sub{ii}; 
    
    % load roi
    dirAnatomy = list_anatomy{ii}; 
    roiPath = fullfile(dirAnatomy, 'ROIs', [roiName '.mat']); 
    [vw, roiExists] = loadROI(vw, roiPath, [],[],1,0); 
    
    % load the ret model
    rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
    rmExists = exist(rmPath, 'file');
    
    % plot coverage if roi and rm exists
    if roiExists && rmExists
        vw = rmSelect(vw, 1, rmPath); 
        vw = rmLoadDefault(vw); 
        rmroi = rmGetParamsFromROI(vw); 
        rmroi.sub = subInitials; 
        contourMatrix = ff_contourMatrix_make(rmroi, vfc, contourLevel);    
    end
    
    %% plot prob map and subject overlay 
    % make 3 channels. grayscale, so make them all the same
    probMap_3c = cat(3, probMap, probMap, probMap);
    % color in the contour
    for bb = 1:3
        channelColor = contourColor(bb);
        temChannel = probMap_3c(:,:,bb); 
        
        % contourMatrix is a logical 2D matrix where the contour points are
        % true
        temChannel(contourMatrix) = channelColor; 
        probMap_3c(:,:,bb) = temChannel; 
    end
    
    % plot the coverage with contour!
    ff_polarPlotFrom3DMatrix(probMap_3c, vfc); 

    % plot properties
    colormap gray
    c = colorbar; 
    
    %% title
    roiNameDescript = ff_stringRemove(roiName, '_rl');
    titleName = {[roiNameDescript '. ' dtName '. ' modelType], [subInitials '. contour' ff_dec2str(contourLevel)]}
    title(titleName, 'FontWeight', 'Bold'); 
    titleNameString = ff_cellstring2string(titleName); 
    
    %% save
    savePath = fullfile(saveDir, [titleNameString]); 
    saveas(gcf, [savePath '.png'], 'png')
    saveas(gcf, [savePath '.fig'], 'fig')
    if dropboxSave
        ff_dropboxSave
    end

end % loop over subjects


