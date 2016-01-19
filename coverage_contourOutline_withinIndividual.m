%% for an individual, plot {contourLevel} contours from multiple stmi type
% example use: coverage is a lot larger for checkers
% show this in the individual

clear all; close all; clc;
bookKeeping; 

%% modify here

% subjects and session
list_subInds = 1; 
list_path = list_sessionRet; 

% roi
roiName = 'left_VWFA_rl';

% saving purposes, should be informative
% can also be empty
titleDescript = 'Words'; 

list_dtNames = {
%     'Checkers'
%     'Checkers1and2'
%     'Checkers2and3'
%     'Checkers1and3'
    'Words'
    'Words1'
    'Words2'
    };

list_rmNames = {
%     'retModel-Checkers-css.mat'
%     'retModel-Checkers1and2-css-left_VWFA_rl.mat'
%     'retModel-Checkers2and3-css-left_VWFA_rl.mat'
%     'retModel-Checkers1and3-css-left_VWFA_rl.mat'
    'retModel-Words-css.mat'
    'retModel-Words1-css-left_VWFA_rl.mat'
    'retModel-Words2-css-left_VWFA_rl.mat'
    };

list_forLegend = {
%     '3 runs'
%     '2 runs'
%     '2 runs'
%     '2 runs'
    '2 runs'
    'Run1'
    'Run2'
    };

legendDescript = list_forLegend;  % list_rmNames

list_colors = {
    [1 0 0]; 
    [.3 1 .3]
    [.3 .3 1]
%     [1 .2 .2];
%     [.2 1 .2];
%     [.2 .2 1];
%     [.9 .9 .1];
    };

contourLevel = 0.9; 

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
vfc.backgroundColor = [.9 .9 .9];
vfc.color           = [1 0 0]; % yet to figure out what this does
vfc.fillColor       = [0 1 0]; % yet to figure out what this does 

% save
saveDropbox = true; 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/contours/CI';


%% end modification section

% number of ret models
numDts = length(list_dtNames); 

% loop over subjects
for ii = list_subInds
    
    % dirVista
    dirVista = list_path{ii};
    chdir(dirVista);
    vw = initHiddenGray; 
    subInitials = list_sub{ii}; 
    
    % load roi
    dirAnatomy = list_anatomy{ii}; 
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName); 
    [vw, roiExists] = loadROI(vw, roiPath, [],[], 1,0);
    
    % initialize final 3D contour matrix (for subject)
    % assumption = bgcolor is a shade of gray
    bgcolor = vfc.backgroundColor(1); 
    ContourMatrix3D = bgcolor*ones(vfc.nSamples, vfc.nSamples, 3); 
    
    for kk = 1:numDts
        
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName); 
        rmExists = exist(rmPath, 'file');
        
        % if both rm and roi exists
        if roiExists && rmExists
            
            vw = rmSelect(vw, 1, rmPath); 
            vw = rmLoadDefault(vw);
            rmroi = rmGetParamsFromROI(vw); 
            rmroi.sub = subInitials; 
            
            % get the contour matrix
            % this is a 2d matrix: 
            % a 128x128 logical with true at the contour
            contourMatrixLogical = ff_contourMatrix_make(rmroi, vfc, contourLevel); 
            
            % store the contour matrix with colr
            contourColor = list_colors{kk};
            
            % loop over channels
            % note that a single pixel will only have one color
            for cc = 1:3
                channelColor = contourColor(cc); 
                temChannel = ContourMatrix3D(:,:,cc); 
                temChannel(contourMatrixLogical) = channelColor;
                ContourMatrix3D(:,:,cc) = temChannel; 
            end % loop over contours
   
        end % if both rm and roi exists
        
    end % loop over ret models (stim types)
    
    %% plot the 3d coverage plot!
    close all; 
    ff_polarPlotFrom3DMatrix(ContourMatrix3D, vfc); 
    
    
    %% plot properties
    
    % dummy objects so can associate legend with color
    p = zeros(numDts,1); 
    for pp = 1:numDts
        hold on; 
        p(pp) = plot(0,0,'Color',list_colors{pp});       
    end
    L = legend(p,legendDescript, 'Location', 'SouthOutside'); 
    
    % title
    roiNameDescript = ff_stringRemove(roiName, '_rl'); 
    titleName = {
        [roiNameDescript '. ' subInitials '.' titleDescript]
        ['ContourLevel: ' num2str(contourLevel)]
        };
    title(titleName, 'FontWeight', 'Bold')
    
    % save
    
    % because colors not saved as printed
    set(gcf, 'inverthardcopy', 'off');
    
    titleNameString = ff_cellstring2string(titleName); 
    ff_savePngAndFig(saveDir, titleNameString); 
    if saveDropbox
        ff_dropboxSave; 
    end
    
end % loop over subjects

