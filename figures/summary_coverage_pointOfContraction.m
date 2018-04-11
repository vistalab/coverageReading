%% Find the point of contraction in the visual field.
% We notice that for 2 different ret models, the theta tends to stay
% similar, and the polar angle tends to shift with respect to the origin.
% Is it possible the contraction happens with respect to elsewhere in the
% visual field?

clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = 1:20; 
list_path = list_sessionRet; 

list_roiNames = {
    'lVOTRC'
    };

vfc = ff_vfcDefault; 
vfc.backgroundColor = [.1 .1 .1];

% list the two where we compare the point the expansion
list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat'
    'retModel-Checkers-css.mat'
    };

% will form a grid with respect to the origin of these points
gridXpoints = [-5 0 1 2 3 4 5 10 15];
gridYpoints = [0]; 

% the range over which color bar
cmapRange = [0 pi]; 

% the colorbar values
% cmapValues = cool_hotCmap(0,128);
% cmapValues = hsvCmap(0,128);
cmapValues = flipud(jetCmap(0,128));



%% intialize

numSubs = length(list_subInds);
numRois = length(list_roiNames);

% grid points & numGridPoints to sample over
[X,Y] = meshgrid(gridXpoints, gridYpoints);
numGridPoints = length(X);

% Table where we keep track of the results
T = table;
T.X = X'; 
T.Y = Y';
T.Error = inf + zeros(numGridPoints,1); 

% vector where we keep track of the "error": the sum of the theta
% differences. Later this will be stored in T.error
errorGrid = zeros(numGridPoints, 1);

%% rmroi cell
rmroiCellAll = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames, 'list_path', list_path)

%% rmroi needs the same voxels for both rmroi models
% In comparing ret models, the collection of voxels may not be the same
% because of the thresholding. In this cell we redefine the rmroi
rmroiCell = cell(size(rmroiCellAll));

for jj = 1:numRois
    for ii = 1:numSubs        
        % get identical voxels for each subject's roi over all ret models
        D = rmroiCellAll(ii,jj,:);
        rmroiCell(ii,jj,:) = ff_rmroiGetSameVoxels(D, vfc);        
    end
end

%% analyze ===============================================================

%% get the original x y data
% form a vector of original x y data for each roi

% concatenated (over subjects) phase data for each roi
% each element in the cell is a struct with x0_rm1 x0_rm2 y0_rm1 y0_rm2
OriginalXY = cell(numRois,1);

for jj = 1:numRois

    x0_rm1 = []; 
    x0_rm2 = []; 
    y0_rm1 = []; 
    y0_rm2 = []; 

    for ii = 1:numSubs
        rmroi1 = rmroiCell{ii,jj,1};
        rmroi2 = rmroiCell{ii,jj,2};

        x0_rm1 = [x0_rm1 rmroi1.x0]; 
        x0_rm2 = [x0_rm2 rmroi2.x0];
        y0_rm1 = [y0_rm1 rmroi1.y0];
        y0_rm2 = [y0_rm2 rmroi2.y0];
        
    end
    s = []; 
    s.x0_rm1 = x0_rm1; 
    s.x0_rm2 = x0_rm2; 
    s.y0_rm1 = y0_rm1; 
    s.y0_rm2 = y0_rm2; 
    
    OriginalXY{jj} = s; 
        
end

%% Loop over grid points, calculate the error and store that in the table T
close all; 

for jj = 1:numRois
    roiName = list_roiNames{jj};
    s = OriginalXY{jj};
    numCenters = length(s.x0_rm1); 
    
    for gg = 1:numGridPoints

        %% loop over grid points
        gridX = X(gg);
        gridY = Y(gg);

        % the thetas with respect to this new fixation point
        % need to re-calcuate in this new cartesian coordinate
        new_x0_rm1 = s.x0_rm1 - gridX; 
        new_x0_rm2 = s.x0_rm2 - gridX; 
        new_y0_rm1 = s.y0_rm1 - gridY; 
        new_y0_rm2 = s.y0_rm2 - gridY; 

        [new_theta_rm1, new_ecc_rm1] = cart2pol(new_x0_rm1, new_y0_rm1);
        [new_theta_rm2, new_ecc_rm2] = cart2pol(new_x0_rm2, new_y0_rm2);

        %% differences of theta
        % we take the absolute value of the theta differences because we
        % are not interestd in the direction of the rotation, just the
        % amount of rotation
        thetaDiff = abs(new_theta_rm2 - new_theta_rm1); 
        thetaDiffNew = thetaDiff; 
        
        % constrain the theta difference to lay between 0 and pi as opposed
        % to 0 and 2pi.
        
        % the indices of thetaDiff that are greater than pi
        indThetaOverRotate = thetaDiff > pi;
        % the values that are greater than pi
        thetaValuesOverRotate = thetaDiff(indThetaOverRotate);
        % xform
        thetaValuesNew = 2*pi - thetaValuesOverRotate; 
        % reassign
        thetaDiffNew(indThetaOverRotate) = thetaValuesNew; 
        
        % get the colors for the new theta differences
        cdata = ff_colormapForValues(thetaDiffNew, cmapValues, cmapRange);

        % the error: sum of the theta differences
        thetaError = sum(thetaDiffNew)
        T.Error(gg) = thetaError; 
        
        %% plotting with respect to this new point of fixation
       
        % initialize polar plot
        figure; 
        axis([-vfc.fieldRange vfc.fieldRange -vfc.fieldRange vfc.fieldRange])
        ff_polarPlot(vfc); 
        hold on; 
        
        for pp = 1:numCenters              
            lineColor = cdata(pp,:);
            plot([x0_rm1(pp) x0_rm2(pp)], [y0_rm1(pp), y0_rm2(pp)], ...
                'Color', lineColor, ...
                'LineWidth',1, 'Marker', 'o', ...
                'MarkerFaceColor', lineColor, ...
                'MarkerSize',4)
        end
        
        % big white dot at the new origin
        plot(gridX, gridY, 'wo', 'markersize', 10, ...
            'markerfacecolor', [1 1 1], 'markeredgecolor', [.1 .1 .1],...
            'Linewidth',2)
        
        % title
        titleName = {
            ['Theta difference. ' roiName]
            ['Origin: (' num2str(gridX) ', ' num2str(gridY) ')']
            ['Error: ' num2str(thetaError)]
            };
        title(titleName, 'fontweight', 'bold', 'color', [1 1 1])
       
        % colorbar
        colormap(cmapValues);
        colorbar; 
        caxis(cmapRange)

    end
end

% print 
T


