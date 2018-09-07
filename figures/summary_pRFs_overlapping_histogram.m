%% plot for the same vox, overlapping pRFs
clear all; close all; clc; 
bookKeeping; 

%% modify here

list_subInds = [1:20]; 

% roiNames
% ASSUME ONE ROI FOR NOW
% list_roiNames = {'LV2v_rl-threshBy-WordsAndCheckers-co0p5'}; 
list_roiNames = {
    'WangAtlas_V1v_left' 
    'WangAtlas_V2v_left' 
    'WangAtlas_V3v_left' 
    'WangAtlas_hV4_left' 
    'WangAtlas_VO1_left' 
    'lVOTRC'
    };

% ret models. ASSUMING TWO
list_dtNames = {
    'Words'
    'Checkers'
    };
list_rmNames = {
    'retModel-Words-css.mat';
    'retModel-Checkers-css.mat';
    };
list_rmDescripts = {
    'Words'
    'Checkers'
    };

% vfc thresh
vfc = ff_vfcDefault; 

%% initialize
numSubs = length(list_subInds);
numRois = length(list_roiNames);
numRms = length(list_rmNames);

linSigCell = cell(numRois, numRms);
linEccCell = cell(numRois, numRms);
linXCell = cell(numRois, numRms);
linYCell = cell(numRois, numRms);

%% get the rmroi for each ret model
rmroiCellTemp = ff_rmroiCell(list_subInds, list_roiNames, list_dtNames, list_rmNames);

%% threshold. for each ROI in each subject, get the same voxels across RMs
rmroiCell = cell(size(rmroiCellTemp));

for jj = 1:numRois
    for ii = 1:numSubs
        rmroiMultiple = rmroiCellTemp(ii,jj,:);
        rmroiCell(ii,jj,:) = ff_rmroiGetSameVoxels(rmroiMultiple, vfc); 
    end
end

%% linearize the size and eccentricity data
% for each ROI and for each RM
% [ldata, theAvg, theSte] = ff_rmroiLinearize(rmroiMultiple, fieldName)

for jj = 1:numRois
    for kk = 1:numRms
        
        rmroiMultiple = rmroiCell(:,jj,kk);
        ldataEcc = ff_rmroiLinearize(rmroiMultiple, 'ecc');
        ldataSig = ff_rmroiLinearize(rmroiMultiple, 'sigma');
        ldataX = ff_rmroiLinearize(rmroiMultiple, 'x0');
        ldataY = ff_rmroiLinearize(rmroiMultiple, 'y0');
        
        linEccCell{jj,kk} = ldataEcc;
        linSigCell{jj,kk} = ldataSig; 
        linXCell{jj,kk} = ldataX; 
        linYCell{jj,kk} = ldataY; 
        
    end
end


%% 

for jj = 1:numRois

    % get data that is linearized across subjects for rm1 and rm2
    x1 = linXCell{jj,1}; 
    x2 = linXCell{jj,2};
    y1 = linYCell{jj,1};
    y2 = linYCell{jj,2};
    sig1 = linSigCell{jj,1};
    sig2 = linSigCell{jj,2};
   
    roiName = list_roiNames{jj};
    
    % loop over voxels
    numVoxels = length(x1); 
    PorOver = zeros(1, numVoxels);
    for vv = 1:numVoxels        
        x1tem = x1(vv); 
        y1tem = y1(vv);
        sig1tem = sig1(vv);
        x2tem = x2(vv);
        y2tem = y2(vv);
        sig2tem = sig2(vv);
        porOver =  ff_areaRFsOverlap(x1tem,y1tem,sig1tem,x2tem,y2tem,sig2tem);
        PorOver(vv) = porOver; 
        
        % print progress
        if ~mod(vv,200)
            display([num2str(vv) '/' num2str(numVoxels)])
        end
    end
      
    % plotting 
    figure; 
    hist(PorOver);
    grid on; 
    xlabel('Percentage of RM1 in RM2', 'fontweight', 'bold')
    ylabel('Number of voxels')
    
    
    % plotting properties
    grid on; 
    titleName = {
        roiName
        };
    title(titleName, 'fontweight', 'bold')
    
    % vertical line
    line([0 0], [0 max(get(gca, 'ylim'))], 'linewidth',2, 'Color', [.6 .6 .6])
    
    
end




%% try single voxel for now, matrix-ify later
% x1tem = 2; 
% y1tem = 2;
% sig1tem = 1;
% x2tem = 2;
% y2tem = 3;
% sig2tem = 1;
% 
% porOver =  ff_areaRFsOverlap(x1tem,y1tem,sig1tem,x2tem,y2tem,sig2tem)

% 
% 
% t = 0:0.01:2*pi; 
% 

% 
% X1tem = x1tem + sig1tem*cos(t); 
% Y1tem = y1tem + sig1tem*sin(t);
% 
% X2tem = x2tem + sig2tem*cos(t);
% Y2tem = y2tem + sig2tem*sin(t);
% 
% % plotting
% close all; 
% figure; hold on;
% plot(X1tem, Y1tem, 'color', 'r')
% plot(X2tem, Y2tem, 'color', 'b')
% axis equal;
% 
% % calculating the overlap
% area1 = polyarea(X1tem, Y1tem); % area of rm1
% area2 = polyarea(X2tem, Y2tem); % area of rm2
% if area1 <= area2
%     areaInd = 1; 
% else
%     areaInd = -1;
% end
% 
% [Xint, Yint] = polybool('intersection', X1tem, Y1tem, X2tem, Y2tem);
% plot(Xint, Yint, 'color', 'k', 'linewidth',2);
% 
% areaint = polyarea(Xint, Yint); % area of the intersection
% 
% % ratio of the intersection to the first rm1
% if areaInd == 1
%     porOver = areaint / area1;
% elseif areaInd == -1
%     porOver = - areaint / area2;
% end
% 
% porOver
% 
% 
% 
