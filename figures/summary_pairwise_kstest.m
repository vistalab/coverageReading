%% pairwise comparisons of 2 rm models
% Split off from summary_pairwise_individual because that code got too long
% This one specifically makes a heatMap and fits the bootstrapped (across subjects)
% mean line

close all; clear all; clc; 
 
%% modify here

% 'rory' | 'rkimle'
bookKeepingOption = 'rkimle';
if strcmp(bookKeepingOption, 'rory')
    bookKeeping_rory; 
elseif strcmp(bookKeepingOption, 'rkimle')
    bookKeeping;
end

% session list, see bookKeeping.m
% list_path = list_sessionRoryFace; 
list_path = list_sessionRet; 

% list subject index
% list_subInds = [31:36 38:44]; % Hebrew
list_subInds = [1:12]; %[1:3 5:7] %[31:36 38:44]; % [1:12];
list_subIndsDescript = ' ';

% values to threshold the RM struct by
vfc = ff_vfcDefault; 
vfc.cothresh = 0.2; 
vfc.cothreshceil = 1; 

% whether looking at a subject by subject basis
subIndividually = false; 

% list rois
list_roiNames = {
%     'WangAtlas_V1d_left'
%     'WangAtlas_V1d_right'
%     'right_FFAFace_rl'
    'WangAtlas_V1v_left'
    'WangAtlas_V2v_left'
    'WangAtlas_V3v_left'
    'WangAtlas_hV4_left'
    'WangAtlas_VO1_left'
    'lVOTRC'
%     'WangAtlas_VO2_left'
%     'right_FFAFace_rl'
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'LhV4_rl'
%     'lVOTRC'
%     'rVOTRC'
%     'cVOTRC'
%     'WangAtlas_V1v_right'
%     'WangAtlas_V2v_right'
%     'WangAtlas_V3v_right'
%     'WangAtlas_hV4_right'
%     'WangAtlas_VO1_right'
%     'rVOTRC'
%     'WangAtlas_V1d_left'
%     'WangAtlas_V2d_left'
%     'WangAtlas_V3d_left'
%     'WangAtlas_V3A_left'
%     'WangAtlas_V3B_left'
%     'WangAtlas_IPS0_left'
%     'WangAtlas_IPS1_left'
%     'WangAtlas_LO1'    
%     'WangAtlas_LO2'   
    };

% ret model dts
list_dtNames = {
    'Words'
    'Checkers'
    };

% ret model names
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% ret model comments
list_rmDescripts = {
    'Words'
    'Checkers'
    };

% field to plot. Ex:  
% 'co': variance explained 
% 'ecc': eccentricity 
% 'sigma': effective size 
% 'sigma1': sigma major
% 'numvoxels' for number of voxels in roi
% fieldToPlotDescript is for axis labels and plot titles
%     'sigma'       : effective sigma
%     'sigma1'      : sigma major
%     'ecc'         : eccentricity
%     'co'          : variance explained 
%     'exponent'    : exponent
%     'betaScale'   : how much to scale the predicted tseries by
%     'meanMax'     : mean of the top 8 values
%     'meanPeaks'   : mean of the outputs of matlab's meanPeaks
list_fieldNames  = {    
%     'co'
%     'ecc'
%     'sigma'
    'ph'
    }; 

list_fieldDescripts = {
%     'variance explained'
%     'eccentricity'
%     'sigma effective'
%     'sigma'
    'polar angle'
    }; 

% which plots do we want? lots we can make ...
plot_fit = true; 

% transparency of the plots
alphaValue = 0.4; 

% significance for kstest
alphaSig = 0.001; 

% colormap for histogram
% cmapValuesHist = colormap('pink');
% cmapValuesHist_tem = colormap('hot');
% cmapValuesHist = cmapValuesHist_tem(2:55, :); 
colormap(zeros(64,3)); % matlab has funky behavior where the size of this influences the size of all future colorbars...
cmapValuesHist = colormap('pink');
close; 

% location of the colorbar
% default: 'eastoutside'
% 'southoutside': 
cbarLocation = 'eastoutside';

%% end modification section

numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

% number of fields
numFields = length(list_fieldNames);

% rm descriptions
rm1Descript = list_rmDescripts{1}; 
rm2Descript = list_rmDescripts{2}; 


A = cell(numFields*numRois, 4);

%% get the cell of rms so that we can threshold
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, ...
    'list_path', list_path, 'bookKeeping', bookKeepingOption);


%% Threshold and get identical voxels for each subject
% In comparing ret models, the collection of voxels may not be the same
% because of the thresholding. In this cell we redefine the rmroi
rmroiCellSameVox = cell(size(rmroiCell));

for jj = 1:numRois
    for ii = 1:numSubs        
        % get identical voxels for each subject's roi over all ret models
        D = rmroiCell(ii,jj,:);
        rmroiCellSameVox(ii,jj,:) = ff_rmroiGetSameVoxels(D, vfc);        
    end
end

% 

for jj = 1:numRois
    
    roiName = list_roiNames{jj};

    for ff = 1:numFields

        % field-specific properties
        fieldName = list_fieldNames{ff};
        fieldNameDescript = list_fieldDescripts{ff}; 

        if strcmp(fieldName, 'sigma1') 
            maxValue = vfc.sigmaMajthresh(2);
        elseif strcmp(fieldName, 'sigma')          
            maxValue = vfc.sigmaEffthresh(2);
        elseif strcmp(fieldName, 'ecc')
            maxValue = vfc.eccthresh(2);
        elseif strcmp(fieldName, 'co')
            maxValue = 1; 
        elseif strcmp(fieldName, 'exponent')
            maxValue = 2; 
        elseif strcmp(fieldName, 'meanMax')
            maxValue = 20; 
        elseif strcmp(fieldName, 'meanPeaks')
            maxValue = 10; 
        elseif strcmp(fieldName, 'betaScale')
            maxValue = 5; 
        elseif strcmp(fieldName, 'x0') || strcmp(fieldName, 'y0')
            maxValue = vfc.fieldRange;
        elseif strcmp(fieldName, 'ph')
            maxValue = 2*pi; 
        else
            error('Define the maxValue so we can normalize and fit the beta distribution.');
        end
        
        axisLims = [0 maxValue]; 
        BarData1 = [];
        BarData2 = [];

        for ii = 1:numSubs
            
            %%
            subInd = list_subInds(ii);
            
            % rmRois for different ret models
            rmroi1 = rmroiCellSameVox{ii,jj,1}; 
            rmroi2 = rmroiCellSameVox{ii,jj,2};

             if ~isempty(rmroi1)
                 
                % get the data
                x1 = eval(['rmroi1.' fieldName]);
                x2 = eval(['rmroi2.' fieldName]);

                % shift so that the smallest value is 0
                if strcmp(fieldName, 'ph')
                    x1 = x1 + pi; 
                    x2 = x2 + pi;
                end
                
                %% For the mixed effects
                % kstest2 for each subject
                [hs,ps] = kstest2(x1, x2, 'alpha', alphaSig);
                
                % store the ks results for each subject for each ROI
                As{ii,1} = subInd; 
                As{ii,2} = ff_stringRemove(roiName, '_rl');
                As{ii,3} = fieldName;
                As{ii,4} = hs;
                As{ii,5} = ps;
                
                
                %% concatenate
                BarData1 = [BarData1, x1];
                BarData2 = [BarData2, x2];
           
            end
        end % end loop over subjects
        Ts = cell2table(As, 'VariableNames', {'subInd', 'roiName', 'fieldName', 'H', 'pValue'});
        TSubjects{jj} = Ts; 
            
        %% conduct the statistical test here and put it into a table
        [h,p] = kstest2(BarData1, BarData2, 'alpha', alphaSig);
        
        % put the data into a table
        % table things. 
        % (1)roiName (2)fieldName (3) hypothesis (4)pValue
        tind = (jj-1)*numFields + ff; 
      
        A{tind,1} = ff_stringRemove(roiName, '_rl');
        A{tind,2} = fieldName;
        A{tind,3} = h;
        A{tind,4} = p;
       
    end % loop over fields

end % loop over rois

% Print table -- pooled
T = cell2table(A, 'VariableNames', {'roiName', 'fieldName', 'H', 'pValue'})

% To print the table from the individual subjects
TSubjects{3}

