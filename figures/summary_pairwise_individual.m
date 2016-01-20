%% pairwise comparisons of 2 rm models

close all; clear all; clc; 
bookKeeping; 

%% modify here

% session list, see bookKeeping.m
list_path = list_sessionRet; 

% list subject index
list_subInds = [1:4 6:19];

% whether looking at a subject by subject basis
subIndividually = true; 

% list rois
list_roiNames = {
%     'LV1_rl'
    'left_VWFA_rl';
%     'right_VWFA_rl';
    };

% ret model dts
list_dtNames = {
    'Words'
    'Words'
    };

% ret model names
list_rmNames = {
    'retModel-Words.mat'
    'retModel-Words-css.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words. Linear'
    'Words. CSS'
    };

% values to threshold the RM struct by
h.cothresh = 0;
h.eccthresh = [0 15];
h.sigmathresh = [0 30];
h.minvoxelcount = 0;


% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
list_fieldNames  = {
    'sigma1'
    'ecc'
    'co'
    }; 

list_fieldDescripts = {
    'prf Size'
    'eccentricity'
    'varExp'
    }; 

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/rmComparison';

%% end modification section

% number of subjects
numSubs = length(list_subInds);

% number of rois
numRois = length(list_roiNames);

% number of fields
numFields = length(list_fieldNames);

% initialize data struct
D = cell(numSubs, numRois, 2); 

% rm descriptions
rm1Descript = list_rmDescripts{1}; 
rm2Descript = list_rmDescripts{2}; 

% loop over subjects
for ii = 1:numSubs
    
    subInd = list_subInds(ii); 
    dirVista = list_path{subInd}; 
    dirAnatomy = list_anatomy{subInd};
    chdir(dirVista); 
    vw = initHiddenGray; 
    
    % loop over the 2 rm models
    for kk = 1:2
        
        % dt and rm name and path
        dtName = list_dtNames{kk};
        rmName = list_rmNames{kk};
        rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
        
        % load rm 
        vw = rmSelect(vw, 1, rmPath);
        vw = rmLoadDefault(vw);
        
        % loop over the rois
        for jj = 1:numRois
            
            % roi name and path
            roiName = list_roiNames{jj};
            roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
            
            % load roi
            [vw, roiExists] = loadROI(vw, roiPath, [], [], 1, 0);
            
            if roiExists 
                rmroi = rmGetParamsFromROI(vw);
                D{ii,jj,kk} = rmroi; 
            end
            
        end
        
    end

end


%% plotting

for ii = list_subInds
    % subjec initials
    subInitials = list_sub{ii}; 
    
    for jj = 1:numRois
        % roiName
        roiName = list_roiNames{jj};
        if strcmp(roiName(end-2:end), '_rl')
            roiNameDescript = roiName(1:end-3); 
        else
            roiNameDescript = roiName; 
        end
        
        % rmRois for different ret models
        rmroi1 = D{ii,jj,1}; 
        rmroi2 = D{ii,jj,2};
        
        
        for ff = 1:numFields
            % field name
            fieldName = list_fieldNames{ff};
            fieldNameDescript = list_fieldDescripts{ff}; 
            
            % get the data
            x1 = eval(['rmroi1.' fieldName]);
            x2 = eval(['rmroi2.' fieldName]);
            
            % go! plot
            figure; 
            plot(x1, x2, '.k'); 
            grid on; 
            identityLine
            
            % title 
            titleName = ['RetModel Pairwise Comparison. ' fieldNameDescript '. ' roiNameDescript '. ' subInitials]; 
            title(titleName, 'FontWeight', 'Bold')
            
            % axes. rm1 on x. rm2 on y. 
            xlabel(rm1Descript)
            ylabel(rm2Descript)
            
            % save
            savePath = fullfile(saveDir, titleName);
            saveas(gcf, [savePath '.png'], 'png'); 
            saveas(gcf, [savePath '.fig'], 'fig'); 
            
        end
        
    end
    
end

