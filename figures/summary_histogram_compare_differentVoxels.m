%% Make a histogram of the pRF distributions (size, eccentricity, etc)
% NOTE that in this version, we don't use the same voxels for the two
% distribtions
clear all; close all; clc;
bookKeeping; 

%% modify here

% list subject index
list_subInds1 = [1:20];
list_subInds2 = [31:36 38 39]; 

% values to threshold the RM struct by
vfc1 = ff_vfcDefault_Hebrew; 
vfc2 = ff_vfcDefault_Hebrew;  

% binCenters = [0:vfc.fieldRange/10:vfc.fieldRange];
binCenters1 = [0:7];
binCenters2 = [0:7];

% list rois
% make sure both subject populations have these ROIs
list_roiNames = {
    'LV1_rl'
    'LV2v_rl'
    'LV3v_rl'
%     'LhV4_rl'
%     'lVOTRC'
%     'LV2d_rl'
%     'LV3d_rl'
%     'LV3ab_rl'
%     'LIPS0_rl'
    };

% whether or not we want to control for the same voxels over all rms
sameVoxels = true; 

% Ret model
dtName1 = {'Words'};
dtName2 = {'Words_Hebrew'}; 

% ret model names
rmName1 = {'retModel-Words-css.mat'};
rmName2 = {'retModel-Words_Hebrew-css.mat'};

% ret model comments
rmDescript1 = 'Words (large bars)';
rmDescript2 = 'Words (small bars)';

list_rmColors = [
    [1 0 0]
    [0 0 1]
    ];

% fieldNames  
%     'sigma'
%     'sigma1'
%     'ecc'
%     'co'
%     'exponent'
%      'phase'
fieldName = 'ecc'; 

% fieldName descript
%     'sigma effective'
%     'sigma major'
%     'eccentricity'
%     'varExp'
%     'exponent'
%     'theta'
fieldNameDescript = 'eccentricity';

% what plots to make
plot_beta = true;        % fit a beta distribution to the data

%% initialize things
numRois = length(list_roiNames);

%% get the cell of rms so that we can threshold
rmroiCell1Temp = ff_rmroiCell(list_subInds1, list_roiNames, dtName1, rmName1);
rmroiCell2Temp = ff_rmroiCell(list_subInds2, list_roiNames, dtName2, rmName2);

%% threshold the rmroi cell

rmroiCell1 = cell(size(rmroiCell1Temp)); 
rmroiCell2 = cell(size(rmroiCell2Temp));

for jj = 1:numRois
    for ii = 1:size(rmroiCell1Temp,1)
        rmroiUnthresh = rmroiCell1Temp{ii, jj, 1}; 
        rmroi = ff_thresholdRMData(rmroiUnthresh, vfc1);
        rmroiCell1{ii,jj,1} = rmroi; 
    end 
end

for jj = 1:numRois
    for ii = 1:size(rmroiCell2Temp,1)
        rmroiUnthresh = rmroiCell2Temp{ii, jj, 1}; 
        rmroi = ff_thresholdRMData(rmroiUnthresh, vfc2);
        rmroiCell2{ii,jj,1} = rmroi; 
    end     
end

% plotting
maxValue1 = max(binCenters1); 
minValue1 = min(binCenters1);
maxValue2 = max(binCenters2);
minValue2 = min(binCenters2);

maxmax = max(maxValue1, maxValue2);
minmin = min(minValue1, minValue2);
axisLims = [minmin-1 maxmax+1]; 

rmColor1 = list_rmColors(1,:);
rmColor2 = list_rmColors(2,:);

close all; 
for jj = 1:numRois
    
    %%
    roiName = list_roiNames{jj};
    
    % linearize the data    
    LData = cell(1,2); 
   
    rmroiSubs1 = rmroiCell1(:,jj,1);         
    ldata1 = ff_rmroiLinearize(rmroiSubs1, fieldName);
    rmroiSubs2 = rmroiCell2(:,jj,1);
    ldata2 = ff_rmroiLinearize(rmroiSubs2, fieldName);

    LData{1} = ldata1; 
    LData{2} = ldata2; 
    
    % plotting
    figure; hold on; 

    [count1, center1] = hist(ldata1,binCenters1); 
    count1Norm = count1/(sum(count1));
    [count2, center2] = hist(ldata2,binCenters2); 
    count2Norm = count2/(sum(count2));
       
    bar(center1, count1Norm, 'FaceColor', rmColor1);
    bar(center2, count2Norm, 'Facecolor', rmColor2);
        
    % plot properties
    alpha(0.5)
    grid on; 
    hold off; 
    
    xlim(axisLims)
    titleName = {
        [roiName]
        [fieldNameDescript]
        };
    title(titleName, 'fontweight', 'bold')
    
    xlabel(fieldName)
    ylabel('Percentage of voxels');
    legend(rmDescript1, rmDescript2)

    
     %% fit beta distributions to the marginal distributions
    if plot_beta

        % Fit it. 
        % First normalize because the beta distribution is defined on
        % the open interval (0,1)
        BarData1 = LData{1}; 
        BarData2 = LData{2};
        BarData1Norm = BarData1 / maxValue1; 
        BarData2Norm = BarData2 / maxValue2;       
        
        % Bar histogram values
        rmColor1 = list_rmColors(1, :);
        rmColor2 = list_rmColors(2, :);
        [count1, center1] = hist(BarData1,binCenters1); 
        [count2, center2] = hist(BarData2, binCenters2);
        
        % normalize so it fits the beta fit
        barArea1 = trapz(center1, count1); 
        barArea2 = trapz(center2, count2); 
        
        
        % Get the beta fits
        [phat1, pci1] = betafit(BarData1Norm, 0.05);
        [phat2, pci2] = betafit(BarData2Norm, 0.05);
        betaX = linspace(0,1);
        betaY1 = betapdf(betaX, phat1(1), phat1(2));
        betaY2 = betapdf(betaX, phat2(1), phat2(2));

        % Plot the curves
        % The area under the curve will be maxValue^2
        figure; hold on; 
        plot(betaX*maxValue1, betaY1/(maxValue1), 'Color', rmColor1, 'Linewidth', 3)
        plot(betaX*maxValue2, betaY2/(maxValue2), 'Color', rmColor2, 'Linewidth', 3) 
               
        % Plot the bars
        % Normalize the histogram so the area of the histogram is 1
        barArea = trapz(center1, count1);
        bar(center1, count1/sum(count1), 'FaceColor', rmColor1, 'FaceAlpha', 0.2, ...
            'EdgeColor', 'none', 'BarWidth',0.9);
        bar(center2, count2/sum(count2), 'FaceColor', rmColor2, 'FaceAlpha', 0.2, ...
            'EdgeColor', 'none', 'BarWidth',0.9);


        % Plot properties
        grid on; 
        xlim(axisLims)
        xlabel(fieldNameDescript)
        ylabel('Number of voxels')
        
        % Descriptive things
%         returnString = newline; 
%         a1string = ['a: ' num2str(phat1(1)), '   (', num2str(pci1(1,1)), ',', num2str(pci1(2,1)), ')'];
%         a2string = ['a: ' num2str(phat2(1)), '   (', num2str(pci2(1,1)), ',', num2str(pci2(2,1)), ')'];
%         b1string = ['b: ' num2str(phat1(2)), '   (', num2str(pci1(1,2)), ',', num2str(pci1(2,2)), ')'];
%         b2string = ['b: ' num2str(phat2(2)), '   (', num2str(pci2(1,2)), ',', num2str(pci2(2,2)), ')'];
%         
%         legend({
%             [rmDescript1, returnString, a1string, returnString, b1string]             
%             [rmDescript2, returnString, a2string, returnString, b2string]
%             }, 'location', 'northeastoutside');
%                
        titleName = {
            ['Beta distribution. ' roiName]
            [rmDescript1 ' and ' rmDescript2]
            };
        title(titleName, 'fontweight', 'bold')

    end
       
end
