% we think the shape of the coverage is wider than it is tall
% characterize this with the ellipse parameters

clc; close all; clear all; 
bookKeeping; 

%%
list_path = list_sessionRet; 
list_subInds = [1:15, 17:21];
list_roiNames = {
	'left_VWFA_rl'
% 	'right_VWFA_rl'
	};

dtName = 'Words';
rmName = 'retModel-Words-css.mat';


%% define and initialize things
numSubs = length(list_subInds);
numRois = length(list_roiNames);

ellipseParams = cell(numSubs, numRois);

%% do things

for ii = 1:numSubs
	subInd = list_subInds(ii);
	dirVista = list_path{subInd};
	dirAnatomy = list_anatomy{subInd};
	chdir(dirVista);
	vw = initHiddenGray; 
	
	% load rmModel
	rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
	vw = rmSelect(vw, 1, rmPath);
	vw = rmLoadDefault(vw);
	
	for jj = 1:numRois
		roiName = list_roiNames{jj};
		roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
		vw = loadROI(vw, roiPath, [],[],1,0);
		
		% plot the coverage
		
		% get the ellipse parameters
		ff_fit_ellipse;
		ellipse_t = []; 
		ellipseParams{ii,jj} = ellipse_t;
	
	end
end	

%% plot it

% which one is the longer axes?
% rfDrawGaussian?

% how many degrees is the longer axes from the vertical position?
% 0 would mean the ellipse is more vertical than horizontal
% 90 would mean the ellipse is more horizontal than vertical


% make a plot that plots the angle of the major axes with a dot and labels with subject initials





