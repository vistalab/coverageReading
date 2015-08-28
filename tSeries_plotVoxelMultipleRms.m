%% plot the raw time series for the same voxel to different stimuli
% for example: a word-selective voxel.
% We may want to show that it has higher amplitude to words to it does to
% faces (say)

close all; clear all; clc;
chdir('/biac4/wandell/data/reading_prf/coverageReading/');
bookKeeping; 

%% modify here

% subject index, as stored in bookKeeping
subInd = 1; 

% session list as a string
listName =  'list_sessionPath';

% coords of the voxel we want. a 3 x 1  vector!!!!!!!!
% we can find these coordinates from the rmPlotGUI
% alternatively, if we specify an ROI, it will do this for every voxel in
% the roi
points = 'lh_VWFA_rl';

% time series of voxels individually (1) or of the mean tseries of the roi (0)?
individualVoxel = 1; 

% names of the 2 stim types
list_stimTypes = {
    'Words'
%    'Checkers'
    'FalseFont'
%    'WordAverage';
%    'WordSmall';
%     'WordLarge';
%      'FaceSmall';
%     'FaceLarge';
    };


% colors corresponding to stim types
list_colors = {
    [.9 .1 .6];
%    [.8  .3 .3];
%     [.2 .8 .7];
     [.4 .9 .3];
    };

% save directory
saveDir = '/sni-storage/wandell/data/reading_prf/forAnalysis/images/single/tSeries';


%% end modification section
%% define things
% number of stim types
numStims = length(list_stimTypes);

% session list
theList = eval(listName); 

%% the view
% subject's vista dir. go there. initalize the vew
dirVista = theList{subInd}; 
chdir(dirVista); 
vw = initHiddenGray; 

% subject's anatomy directory
dirAnatomy = list_anatomy{subInd};


%% are we doing this for a single voxel or for an entire roi?

if isnumeric(points)
    
    % if a single voxel, assign the voxel to have these coordinates
    coords = points;
       
elseif ischar(points)
     
    % roi path
    roiName = points; 
    roiPath = fullfile(dirAnatomy, 'ROIs', roiName);
    
    % load the roi into the view
    vw = loadROI(vw, roiPath, [], [], 1, 0);
    
    % get the roi struct
    ROI = viewGet(vw, 'roistruct');
    
    % get the coordinates
    coords = viewGet(vw, 'roicoords');
    
end

%% intialize the main struct
% number of voxels
numVoxels = size(coords,2);
if ~individualVoxel
    numVoxels = 1; 
end


% TS (timeseries) info for all voxels
TSAllVoxels = cell(numVoxels, 1);

for vv = 1:numVoxels
    % intialize where we'll store the time series
    % TS will be a cell of size numStimTypes x 2
    % where the first column is frameNumbers
    % and the second column is tSeries
    % frameNumbers and tSeries are the outputs of plotMeanTSeries
    TS = cell(numStims,2); 
    TSAllVoxels{vv} = TS; 
end

%% do it! ----------------------------------------------------------------

%% loop over the voxels
for vv = 1:numVoxels
    
    % this voxel's coordinates
    voxCoords = coords(:, vv);
    if ~individualVoxel
        voxCoords = coords; 
    end
    
    % delete the individual voxel rois to avoid clutter, if we are loading
    % an entire roi
    if vv > 2
        vw = deleteROI(vw);
    end
    
    % time series is obtained by plotting the mean tseries form the view
    % this is more convenient than just grabbing from a nifti for example,
    % because things are raw2percent signal change is taken care of here.
    % thus we have to create an roi for the single voxel
 
    % and make the temporary ROI struct from the given coordinates
    % and add it to the view
    [vw, ROI] = ff_temROIStructFromCoords(vw, voxCoords);

    % get the time series for the various stim types
    for kk = 1:numStims

        % current data type. set the view to have this dt
        dtName = list_stimTypes{kk};
        vw = viewSet(vw, 'curdt', dtName);

        % get the time series
        % plotMeanTSeries will return <data> which has 2 fields
        % frameNumbers: [96x1 double]
        % tSeries: [96x1 single]    
        data = plotMeanTSeries(vw);

        % store the data so we can plot it later
        TS{kk,1} = data.frameNumbers;
        TS{kk,2} = data.tSeries; 

    end

    % store it
    TSAllVoxels{vv} = TS; 
    
    % keep track of progress. time consuming step
    display(['Voxel #' num2str(vv) ' completed.' num2str(numVoxels) ' total.'])
    
end

%% do the plotting -----------------------------------------------------

for vv = 1:numVoxels
    close all; figure; 
    
    % voxel coordinates
    voxCoords = coords(:,vv);
    
    % voxel coordinates as a string, for saving purposes
    tem = num2str(voxCoords');
    voxCoordsString = ['[' tem ']'];
    if ~individualVoxel
        voxCoordsString = points;
    end
    
    % current voxel TS info
    TS = TSAllVoxels{vv};
    
    
    for kk = 1:numStims

        % color corresponding to stim type
        stimColor = list_colors{kk}; 

        plot(TS{kk,1}, TS{kk,2}, 'Color', stimColor, ...
            'LineWidth', 2);
        hold on

    end

    %% prettify the graph
    grid on; 
    legend(list_stimTypes)

    % axes labels
    xlabel('Time (secs)')
    ylabel('Percent BOLD Change (%)')

    % save
    subInitials = list_sub{subInd};
    titleName = [subInitials '. tseries from ' voxCoordsString];
    title(titleName, 'FontWeight', 'Bold')
    saveas(gcf, fullfile(saveDir, [titleName '.png']), 'png')
    saveas(gcf, fullfile(saveDir, [titleName '.fig']), 'fig')
    
end

