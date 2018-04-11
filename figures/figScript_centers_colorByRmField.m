%% Hebrew FOV analysis. Visualizing shifts in eccentricity
% Hashing: 
% Plot the centers of pRFs as measured by English stimuli
% Color the dot centers by its difference when measured with Hebrew stimuli

close all; clear all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20; %[31:36 38]; 

% list rois
% 'lVOTRC.mat'
% 'lVOTRC-threshBy-Words-co0p05.mat'
% 'lVOTRC-threshBy-CheckerModel-co0p2.mat'
% 'lVOTRC-threshBy-WordModel-co0p2.mat'
list_roiNames = {
    'lVOTRC'
    'rVOTRC'
    'cVOTRC'
    };

% ret model dts
% 2nd - 1st
list_dtNames = {
    'Words'
    'Checkers'
    };

% ret model names
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% values to threshold the RM struct by
vfc = ff_vfcDefault;  
vfc.backgroundColor = [.1 .1 .1];

% Location of the dots the 1st (1) or the 2nd rm (2)? 
rmCenter = 1; 

% what rm field to base the coloring on
% recall that this is the difference of ret models
%     'sigma1'
%     'ecc'
%     'co'
%     'exponent'
fieldName = 'sigma1';
fieldNameDescript = 'prf size';

% the range over which color bar
cmapRange = [-15 15];   % eccentricty
% cmapRange = [-1 1]; % variance explained
% cmapRange = [-15 15]; % prf size

% the colorbar values
% cmapValues = cool_hotCmap(0,128);
% cmapValues = coolhotGrayCmap(0,128);
cmapValues = flipud(jetCmap(0,128));

%% intialize some things
numRois = length(list_roiNames);
numSubs = length(list_subInds);

% cell for linearizing the data (a vector for each ROI)
L_data = cell(1, numRois);
X_data = cell(1, numRois);
Y_data = cell(1, numRois);

rmDescript1 = list_dtNames{1};
rmDescript2 = list_dtNames{2};

%% get the cell of rms so that we can threshold
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

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

%% Linearize the data
% Take the difference between 2 rms. 
% Also store the x and y data
for jj = 1:numRois
    ldata = []; 
    xdata = [];
    ydata = []; 
    
    for ii = 1:numSubs
        rmroi1 = rmroiCellSameVox{ii,jj,1};
        rmroi2 = rmroiCellSameVox{ii,jj,2};
        
        data1 = eval(['rmroi1.' fieldName]);
        data2 = eval(['rmroi2.' fieldName]);
        
        fieldDiff = (data2 - data1); 
        ldata = [ldata fieldDiff];
        
        
        temx0 = eval(['rmroi' num2str(rmCenter) '.x0']);
        temy0 = eval(['rmroi' num2str(rmCenter) '.y0']);
        xdata = [xdata temx0]; % location of center is the first ret model specified
        ydata = [ydata temy0]; % location of center is the first ret model specified
        
    end
    
    L_data{jj} = ldata; 
    X_data{jj} = xdata;
    Y_data{jj} = ydata;
    
end

% Get a colormap according to the linearized data in L_data

for jj = 1:numRois
    
    ldata = L_data{jj}; 
    cdata = ff_colormapForValues(ldata, cmapValues, cmapRange);
    
    C_data{jj} = cdata; 
    
end

% plotting
close all; 

for jj = 1:numRois
    
    X = X_data{jj};
    Y = Y_data{jj};
    C = C_data{jj};
    
    roiName = list_roiNames{jj};
    
    %% plot
    figure; 
    scatter(X,Y,[],C ,'filled')
    
    
     % Limit plot to visual field circle
    axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])

    % polar plot
    ff_polarPlot(vfc); 
    
    % colorbar
    c = colorbar;
    colormap(cmapValues)
    set(c, 'Color', [1 1 1])
    caxis(cmapRange)
    
    titleName = {
        [fieldNameDescript ' difference']
        [rmDescript2 ' - ' rmDescript1]
        roiName
        ['Center Location: ' list_dtNames{rmCenter}]
        };
    
    title(titleName, 'fontweight', 'bold', 'color', [1 1 1]);
    
    
    
end

