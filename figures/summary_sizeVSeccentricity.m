%% size vs. eccentricity for all subjects
clear all; close all; clc;
chdir('/biac4/wandell/data/reading_prf/')
bookKeeping; 

%%
list_path = list_sessionRet; 
list_subInds = [1:20]; % [16 14 4 1 20 11]%
roiName = 'left_VWFA_rl';

dtName = 'Words';
rmName = 'retModel-Words-css.mat';

list_colors = list_colorsPerSub; 

% vfc threshold
vfc = ff_vfcDefault(); 

% do we want to plot line
plotBestFitLine = false; 


%% define and initialize things
numSubs = length(list_subInds);
rmroiParams = cell(numSubs);

%% do things

for ii = 1:numSubs
	subInd = list_subInds(ii);
    subInitials = list_sub{subInd};
	dirVista = list_path{subInd};
	dirAnatomy = list_anatomy{subInd};
	chdir(dirVista);
	vw = initHiddenGray; 
	
	% load rmModel
	rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
	vw = rmSelect(vw, 1, rmPath);
	vw = rmLoadDefault(vw);

	roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
	vw = loadROI(vw, roiPath, [],[],1,0);
	
	% get the rmroi. threshold it. and store it
	tem = rmGetParamsFromROI(vw); 
    tem.subInitials = subInitials; 
	rmroi = ff_thresholdRMData(tem, vfc); 
	rmroiParams{ii} = rmroi; 

end	

%% plot size (y axis) by eccentricity (x axis)
close all; figure(); 
hold on; 
markerSize = 4; 
markerType = 'o';
hLegend = zeros(1,numSubs);

for ii = 1:numSubs
	subInd = list_subInds(ii);
	thisColor = list_colors(subInd,:); 
	rmroi = rmroiParams{ii}; 
	
	% cartesian to polar coordinates
	[theta,ecc] = cart2pol(rmroi.x0,rmroi.y0); 
	sze = rmroi.sigma; % TODO check var name
	
	% plot the points
	p = plot(ecc, sze, markerType, 'Color', thisColor, 'MarkerSize', markerSize, 'MarkerFaceColor',thisColor)
	
	% plot the best fitting line
	coeffs = polyfit(ecc, sze, 1);
    lin = linspace(0, vfc.eccthresh(2)); 
    y = coeffs(2) + lin*coeffs(1); 

    if plotBestFitLine
        plot(lin,y, '-','Color', thisColor, 'LineWidth',2.5); 
    end
    
    hLegend(ii) = p; 
	
end

grid on; 
xlabel('Ecc. (Vis Ang Deg)')
ylabel('Size. (Vis Ang Deg)')
axis([0 15 0 15])

% title
titleName = ['Size vs Eccentricity. ' ff_stringRemove(roiName, '_rl')];
title(titleName, 'FontSize', 14, 'FontWeight', 'Bold')

% make a string with the subject's ID for is
subStringCell = ff_stringSubInd(list_subInds);
legend(hLegend, subStringCell, 'Location', 'eastoutside')


% save
ff_dropboxSave;
