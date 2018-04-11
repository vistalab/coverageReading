%% Hebrew FOV analysis. Visualizing shifts in center
% Compare 2 ret models. Connect the centers with a line that is colored
% with the shift in theta

close all; clear all; clc; 
bookKeeping; 

%% modify here

list_subInds = [31:36 38]; 

list_path = list_sessionRet; 

% list rois
% 'lVOTRC.mat'
% 'lVOTRC-threshBy-Words-co0p05.mat'
% 'lVOTRC-threshBy-CheckerModel-co0p2.mat'
% 'lVOTRC-threshBy-WordModel-co0p2.mat'
% 'lVOTRC-threshBy-WordsAndCheckers-co0p2.mat'
list_roiNames = {
%     'LV1_rl'
%     'LV2v_rl'
%     'LV3v_rl'
%     'LhV4_rl'
    'lVOTRC'
%     'lVOTRC-threshBy-WordsOrCheckers-co0p2'
%     'lVOTRC-threshBy-Words_HebrewAndWords_English-co0p05.mat'
    };

% ret model dts
% 2nd - 1st
list_dtNames = {
    'Words_Hebrew'
    'Words_English'
    };

% ret model names
list_rmNames = {
    'retModel-Words_Hebrew-css.mat'
    'retModel-Words_English-css.mat'
    };

list_rmDescripts = {
    'Words_Hebrew'
    'Words_English'
    };

% values to threshold the RM struct by
vfc = ff_vfcDefault_Hebrew;
vfc.cothresh = 0.05; 
vfc.cothreshceil = 1; % 0.2 looking for noise. 1 for normal thresholding
vfc.backgroundColor = [.1 .1 .1];
vfc.eccthresh = [0 vfc.fieldRange];

% the range over which color bar
cmapRange = [0 pi]; 

% the colorbar values
% cmapValues = cool_hotCmap(0,128);
% cmapValues = hsvCmap(0,128);
cmapValues = flipud(jetCmap(0,128));

% transparency of graphs
% alphaValue: specify empty if we want opaque. will be faster
alphaValue = ''; % 0.5;
alphaValueDot = '';  % 0.8; 

% thicker lines for transparent. 1 works well for opaque
lineWidth = 1.5; 

% by definition, when eccentricity does not shift a lot, theta will not
% shift either. We can look at theta shifts in the voxels whose
% eccentricity have shifted a lot
thetaShiftByEccThresh = true; 
eccThresh = 3; 

%% intialize some things
numRois = length(list_roiNames);
numSubs = length(list_subInds);

% cell for linearizing the data (a vector for each ROI)
L_data = cell(1, numRois);

X_rm1 = cell(1, numRois);
Y_rm1 = cell(1, numRois);
X_rm2 = cell(1, numRois);
Y_rm2 = cell(1, numRois);

Ecc_rm1 = cell(1, numRois);
Ecc_rm2 = cell(1, numRois);

rmDescript1 = list_rmDescripts{1};
rmDescript2 = list_rmDescripts{2};

%% get the cell of rms so that we can threshold
rmroiCell = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, 'list_path', list_path);

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

% Linearize the data
% Take the difference between 2 rms. 
% Also store the x and y data
for jj = 1:numRois
    % initializing the difference of the centers' thetas
    ldata = []; 

    % intializing the location of the centers
    xdata_rm1 = [];
    ydata_rm1 = []; 
    xdata_rm2 = [];
    ydata_rm2 = [];
    
    % initializing eccentrcity
    ecc_rm1 = [];
    ecc_rm2 = []; 
    
    
    for ii = 1:numSubs
        rmroi1 = rmroiCellSameVox{ii,jj,1};
        rmroi2 = rmroiCellSameVox{ii,jj,2};
        
        % some subjects don't have 
        if ~isempty(rmroi1) & ~isempty(rmroi2)
            data1 = rmroi1.ph;
            data2 = rmroi2.ph;

            % the difference between centers' thetas.
            % this will determine the color of the line
            % we take absolute value because we are interested in the magnitude
            % of the rotation and not the direction
            fieldDiffOver = abs(data2 - data1);  

            % Note that the difference will range between 0 and 2pi. 
            % We want to constrain values to be between and pi (again not 
            % interested in the direction of the rotation but the magnitude of it)
            % For values greater than pi, subtract it from 2pi
            fieldDiff = ff_polarAngleBetween0AndPi(fieldDiffOver);

            ldata = [ldata fieldDiff];

            % the location of the pRF centers
            xdata_rm1 = [xdata_rm1 rmroi1.x0]; 
            ydata_rm1 = [ydata_rm1 rmroi1.y0]; 

            xdata_rm2 = [xdata_rm2 rmroi2.x0]; 
            ydata_rm2 = [ydata_rm2 rmroi2.y0]; 

            ecc_rm1 = [ecc_rm1 rmroi1.ecc];
            ecc_rm2 = [ecc_rm2 rmroi2.ecc];
        end
        
    end
    
    
    
    L_data{jj} = ldata; 
    
    X_rm1{jj} = xdata_rm1;
    Y_rm1{jj} = ydata_rm1;
    
    X_rm2{jj} = xdata_rm2;
    Y_rm2{jj} = ydata_rm2;
    
    Ecc_rm1{jj} = ecc_rm1; 
    Ecc_rm2{jj} = ecc_rm2;
    
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
    
    %% data
    ldata = L_data{jj}; 
    
    X1 = X_rm1{jj};
    Y1 = Y_rm1{jj};
    
    X2 = X_rm2{jj};
    Y2 = Y_rm2{jj};
    
    C = C_data{jj};
    
    ecc_rm1 = Ecc_rm1{jj}; 
    ecc_rm2 = Ecc_rm2{jj};
    
    roiName = list_roiNames{jj};
    
    %% initialize polar plot
    % Limit plot to visual field circle
    figure; 
    axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])

    % polar plot
    ff_polarPlot(vfc); 
    hold on; 
    
    % colorbar
    c = colorbar;
    colormap(cmapValues)
    set(c, 'Color', [1 1 1])
    caxis(cmapRange)
    
    %% plot on polar map
    numPoints = length(X1); 

    for pp = 1:numPoints
        lineColor = C(pp,:);
        plot([X1(pp) X2(pp)], [Y1(pp), Y2(pp)], 'Color', lineColor, ...
            'LineWidth',1, 'Marker', 'o', 'MarkerFaceColor', lineColor, ...
            'MarkerSize',4);        
    end
    
    titleName = {
        ['Theta center difference. ' roiName]
        [rmDescript2 ' - ' rmDescript1]
        };
    
    title(titleName, 'fontweight', 'bold', 'color', [1 1 1], 'fontsize', 14);
    
    % also do another plot if thresholding by ecc
    if thetaShiftByEccThresh
        
        figure; 
        axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])
        ff_polarPlot(vfc); 
        hold on; 
        
        for pp = 1:numPoints
            if abs(ecc_rm1(pp) - ecc_rm2(pp)) > eccThresh
                lineColor = C(pp,:);
                    plot([X1(pp) X2(pp)], [Y1(pp), Y2(pp)], 'Color', lineColor, ...
                        'LineWidth',1, 'Marker', 'o', 'MarkerFaceColor', lineColor, ...
                        'MarkerSize',4);   
            end
        end

        titleName = {
            ['Theta center difference. ' roiName]
            ['pRFs greater than ' num2str(eccThresh) ' degs']
            [rmDescript2 ' - ' rmDescript1]
            };

        title(titleName, 'fontweight', 'bold', 'color', [1 1 1], 'fontsize', 14);

        
    end
    
    
    
    %% plot histogram
    figure; 
    
    % statistics
    ldata_median = median(ldata);
    ldata_mode = mode(ldata);
    ldata_mean = mean(ldata);
    
    hist(ldata)
    grid on
    xlim([0 3.3])
    xlabel('pRF rotation (radians)','Fontweight', 'Bold')
    ylabel('Number of voxels', 'Fontweight', 'Bold')
    titleName = {
        ['Thetas center difference. ' roiName]
        [list_rmDescripts{2} ' - ' list_rmDescripts{1}]
        %['Median: ' num2str(ldata_median)]
        %['Mean: ' num2str(ldata_mean)]
        };
    title(titleName, 'Fontweight', 'Bold')
    
    %% incorporate eccentricity shifts
    % we are also interested in how the eccentricity changes as well as the
    % theta shift. it may be, for example, that many voxels do not shift at
    % all, so there theta shift is very small. plot a scatter graph of
    % eccentricity and color the dots based on theta shift
    figure; 
    scatter(ecc_rm1, ecc_rm2, 100, C, 'filled', ...
        'markeredgecolor',[0 0 0])
    % scatterColor = repmat([.8 0 .1], length(ecc_rm1),1)
    % scatter(ecc_rm1, ecc_rm2, 100*ones(1,length(ecc_rm1)), scatterColor, 'filled', ...
    %     'markeredgecolor', [1 1 1], 'linewidth',0.5);
    
    alpha(0.4);    
    axis square;
    
    xlabel([list_rmDescripts{1} ' Eccentricity (deg)'], 'fontweight', 'bold')
    ylabel([list_rmDescripts{2} ' Eccentricity (deg)'], 'fontweight', 'bold')
    
    axis([0 vfc.fieldRange 0 vfc.fieldRange])
    ff_identityLine(gca, [.2 .2 .2])
    
    colormap(cmapValues)
    colorbar
    caxis([cmapRange])
    titleName = {
        'Eccentricity shifts colored by theta shifts'
        [list_rmDescripts{1} ' and ' list_rmDescripts{2}]
        [roiName]
        }
    title(titleName,'FontWeight','bold')
    
    % add lines around the identity line 
    if thetaShiftByEccThresh
        xpoints = linspace(0, vfc.fieldRange); 
        ypoints1 = xpoints + eccThresh;
        ypoints2 = xpoints - eccThresh; 
        hold on; 
        plot(xpoints, ypoints1, ':', 'color', [.6 .6 .6], 'linewidth',2)
        plot(xpoints, ypoints2, ':', 'color', [.6 .6 .6], 'linewidth',2)
    end
    
    %% look at theta shifts for only voxels which have shifted eccentricity
    % pass a given threshold
    if thetaShiftByEccThresh
        figure; 
        eccDiff = abs(ecc_rm1 - ecc_rm2); 
        indsPass = eccDiff > eccThresh; 
        
        ldataPass = ldata(indsPass); 
        hist(ldataPass); 
        titleName = {
            ['Theta shifts in voxels with greater than ' num2str(eccThresh) ' deg shift']
            roiName
            };
        title(titleName, 'fontweight', 'Bold', 'fontsize',14)
        
        grid on; 
        xlim([0 pi])
    end
   
end

