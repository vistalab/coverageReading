%% Reading circuitry field of view paper (2016). Making figures

% Uses this script: coverage_contourCIGraded_acrossSubject.m


%% coverage confidences. ACROSS SUBJECTS
% this will give us a confidence interval
% Have the graph be "graded" in shades -- the part where every contour
% covers will be lightest

clear all; close all; clc; 
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping; 

%% modify here

% the group we want to sample over, as indicated by bookKeeping
list_subInds = [1:15, 17:21];
% [1:15, 17:21] % everyone except bw, rl, mb

% which session? {'list_sessionPath'| 'list_sessionRetFaceWord'}
list_path = list_sessionRet; 

% the roi we're interested in
% 'lh_ventralSurface_rl' 'lh_VWFA_wordVfacescrambled_rl' 'lh_VWFA_fullField_rl' 'left_VWFA_rl'
list_roiNames = {
    'left_VWFA_rl'
    };

% stimulus description, plotting purposes
% corresponds to ret models
list_stimDescript = {
%     'WordLarge. css'
%     'WordSmall. css'
    'Words. css'
%     'Checkers. css'
%     'FaceLarge. css'
%     'FaceSmall. css'
%     'FalseFont. css'
    };

% datatype names
% for each datatype and its corresponding ret model, will LOOP OVER
% SUBJECTS
list_dtNames = {
%     'WordLarge'
%     'WordSmall'
    'Words'
%     'Checkers'
%     'FaceLarge'
%     'FaceSmall'
%     'FalseFont'
    };

% rm names
list_rmNames = {
%     'retModel-WordLarge-css.mat'
%     'retModel-WordSmall-css.mat'
    'retModel-Words-css.mat'
%     'retModel-Checkers-css.mat'
%     'retModel-FaceLarge-css.mat'
%     'retModel-FaceSmall-css.mat'
%     'retModel-FalseFont-css.mat'
    };

% contour level
list_contourLevels = [
    .5
    ];

% vfc threshold
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
vfc.weightBeta      = true;
vfc.cmap            = 'hot';						
vfc.clipn           = 'fixed';                    
vfc.threshByCoh     = false;                
vfc.addCenters      = true;                 
vfc.verbose         = prefsVerboseCheck;
vfc.dualVEthresh    = 0;

% save 
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/group/contours/CI';

% also save a copy to dropbox? convenient when making presentations on
% laptop
saveDropbox = true; 

% save as a probabilistic map?
probMapSave = false; 
probMapDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/data/probMapCoverage';

% comment out this line if we don't want to directly alter colormap
% newcolormap = 0.3 + 0.6*gray(9);

%% calculate and define things

% number of subjects
numSubs = length(list_subInds);

% initialize the figure where we keep adding contour lines
contourFig = figure; 

% number of dts
numDts = length(list_dtNames);

% number of rois
numRois = length(list_roiNames);

% prf thresholding, as defined by vfc
% for folder saving and such
h.threshecc         = vfc.eccthresh; 
h.threshco          = vfc.cothresh; 
h.threshsigma       = 'none'; 
h.minvoxelcount     = 'none';

%% GET COVERAGE INFORMATION

% loop over rois
for jj = 1:numRois
    
    roiName = list_roiNames{jj};
    
    % loop over ret models
    for kk = 1:numDts
       
        stimDescript = list_stimDescript{kk}; 
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        
       % LOOP OVER SUBJECTS
       counter = 0; 
       allRFcov = []; 
       
       for ii = 1:numSubs
           
           % subject index
           subInd = list_subInds(ii);
           
           % vista directory
           dirVista = list_path{subInd};
           chdir(dirVista);
           vw = initHiddenGray; 
           
           % anatomy directory
           dirAnatomy = list_anatomy{subInd};
           
           % load the roi
           roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
           [vw, roiExists] = loadROI(vw, roiPath, [], [], 1, 0);
           
           % load the ret model
           rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
           vw = rmSelect(vw, 1, rmPath);
           rmExists = exist(rmPath, 'file');
           
           % get coverage information if both roi and ret model exists
           if roiExists && rmExists
               
               counter = counter + 1; 
               
               % plot the coverage
               [RFcov, ~, ~, ~, ~] = ff_coverage_plot(vw, vfc);
               close; 

               % store the coverage
               allRFcov(:,:,counter) = double(RFcov);
               
           end 
       end % FINISH LOOPING OVER SUBJECTS
       
       
       %% loop over the contour levels
       for cc = 1:length(list_contourLevels)

           contourLevel = list_contourLevels(cc);

           %% PLOT HERE
           probMap = ff_coverage_gradedContours(allRFcov, contourLevel, vfc);
           
           % mean: to save in user data
           RFmean = mean(allRFcov,3);
           
            %% title
            % roiName - take off the _rl at the end
            if strcmp(roiName(end-2:end),'_rl')
                roiNamePlot = roiName(1:end-3);
            else
                roiNamePlot = roiName;
            end

            titleName = {
                ['ContourFractionGroup. ']
                [roiNamePlot '. ' 'Group. ' stimDescript] 
                ['Contour Level: ' num2str(contourLevel) '. n = ' num2str(counter)]
                [mfilename '.m']
                };
            titleNameString =  ff_cellstring2string(titleName(1:2)); % filename
            title(titleName, 'FontWeight', 'Bold')
            
            %% user data
            paramsAndData.vfc = vfc; 
            paramsAndData.rf = RFmean;
            set(gcf, 'UserData', paramsAndData)
            
            % save as probMap if so desired
            % TODO: make this a function
            if probMapSave
                subsInRoi = counter; 
                stimType = dtName;
                
                % avoid hard coding model type. fragile code here, TODO fix
                if ~isempty(strfind(stimDescript, 'css'))
                    modelType = 'css'; 
                elseif ~isempty(strfind(stimDescript, 'linear'))
                    modelType = 'linear'; 
                end
                
                probMapName = ff_probMapName(roiName, stimType, modelType, contourLevel);
                probMapPath = fullfile(probMapDir, [probMapName '.mat']);
                save(probMapPath, 'probMap');
            end

            %% save
            
            % name of the thresholded folder
            dirThresh = ff_stringDirNameFromThresh(h); 

            % does it exist? make it if no
            dirThreshExists = exist(fullfile(saveDir, dirThresh), 'dir'); 
            if ~dirThreshExists
                chdir(saveDir)
                mkdir(dirThresh)
            end
            
            % thresholded save dir
            threshSaveDir = fullfile(saveDir, dirThresh);
            
            saveas(gcf, fullfile(threshSaveDir, [titleNameString '.png']), 'png')
            saveas(gcf, fullfile(threshSaveDir, [titleNameString '.fig']), 'fig')
            if saveDropbox
                saveDirDropbox = '/home/rkimle/Dropbox/TRANSFERIMAGES';
                saveas(gcf, fullfile(saveDirDropbox, [titleNameString '.png']), 'png');
                saveas(gcf, fullfile(saveDirDropbox, [titleNameString '.fig']), 'fig');
            end
    
       end
       
       
    end % FINISH LOOPING OVER DTS
end % FINISH LOOPING OVER ROIS