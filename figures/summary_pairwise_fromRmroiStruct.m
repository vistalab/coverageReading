%% make histograms or scatter plots 
% ASSUMES the RMROI variable is already made and loaded
% see s_rmroi_make.m 


%% NOTES for the current RMROI
% grab from the script used to make this rmroi

% list of subjects 
list_subInds = [1 4];

% rois we are interested in
list_rois = {
    'CV1_rl';
    'ch_FFA_rl';
    'ch_VWFA_rl';
    };

% rms we're interested in
list_rms = {
    'FaceLarge';
    'FaceSmall';
    'WordLarge';
    'WordSmall';
    };

% values to threshold the RM struct by
h.threshco = 0.3;
h.threshecc = [0 15];
h.threshsigma = [0 30];
h.minvoxelcount = 0;


% field to plot. Ex:  
% variance explained (co), eccentricity (ecc), effective size (sigma)
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
list_fieldToPlot         = {
    'sigma1'
    'ecc'
    'co'
    }; 

list_fieldToPlotDescript = {
    'prf Size'
    'eccentricity'
    'varExp'
    }; 

% save directory
saveDir = '/biac4/wandell/data/reading_prf/forAnalysis/images/working/';


%% define things
% number of subjects
numSubs = length(list_subInds);

% number of rois
numRois = length(list_rois);

% number of rms
numRms = length(list_rms);

% number of fields to plot
numFields = length(list_fieldToPlot); 

% initialize thresholded rmroi
RMROI_thresh = cell(numSubs, numRois, numRms);

% intialize pooled subjected thresholded rmroi
Pooled = cell(numFields, numRois, numRms); 

%% do things
% get the thresholded RMROI
for ii = 1:numSubs
    for jj = 1:numRois
        for kk = 1:numRms
            
            rmroi = RMROI(ii,jj,kk);
            rmroi_thresh = ff_thresholdRMData(rmroi, h); 
            RMROI_thresh{ii,jj,kk} = rmroi_thresh;
            
        end
    end
end


% pool subject's thresholded rmroi data
for jj = 1:numRois
    for kk = 1:numRms

        for ff = 1:numFields
            % clear P for each field
            P = []; 
            
            % this field
            field = list_fieldToPlot{ff}; 

            % we want to pool over subjects
            for ii = 1:numSubs
                
                % this rmroi
                % r = RMROI_thresh{ii,jj,kk};
                r = RMROI{ii,jj,kk}; 

                % p = eval(['r{1}.' field]); % this line when using RMROI_thresh
                p = eval(['r.' field]); % this line when using RMROI
                P = [P p]; 
                
            end
            
            Pooled{ff,jj,kk} = P;

        end
    end
end



%% plot things

% pairwise scatter plot. Large vs small
for ff = 1:numFields
    
    % field to plot and its description
    field           = list_fieldToPlot{ff};
    fieldDescript   = list_fieldToPlotDescript{ff}; 
    
    for jj = 1:numRois
        
        % this roi
        roiName = list_rois{jj}; 
        
        % FACES --------------------------------------------------------------
        xFace = Pooled{ff, jj, 2};  % small faces
        yFace = Pooled{ff, jj, 1};  % large faces
        figure; 
        plot(xFace, yFace, '.k')

        identityLine; 

        % axes labels
        xlabel('Small Faces')
        ylabel('Large Faces')

        % title
        titleName = [roiName '. ' fieldDescript '. Small and Large Faces'];
        title(titleName)

        % save
        saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png');

        % WORDS --------------------------------------------------------------
        xWord = Pooled{ff, jj, 4};  % small faces
        yWord = Pooled{ff, jj, 3};  % large faces
        figure; 
        plot(xWord, yWord, '.k')

        identityLine; 

        % axes labels
        xlabel('Small Words')
        ylabel('Large Words')

        % title
        titleName = [roiName '. ' fieldDescript '. Small and Large Words'];
        title(titleName)

        % save
        saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png');
        saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig');

        
    end

end

