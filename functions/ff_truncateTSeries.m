function vw = ff_truncateTSeries(vw, scanList, timePointsToKeep, newDtName, annotation)
%
% vw = ff_truncateTSeries(vw, scanList, timePointsToKeep, newDtName, annotation)
% Make a new datatype that is called newnewDtName
% 
% Makes the following assumptions:
% - That the truncation will be done for all scans in the existing
% datatype. Though for the most part there will likely only be one scan to
% begin with.
% - That this is being done in the inplane view 
%
% INPUTS
    % vw        : the view. Needs to be an INPLANE. Assumes that it is
                % already set to the datatype (curdt) that we want to be truncated. 
    % scanList  : the scans in datatype curdt that we want truncated. Ex:
                % [1 2]
    % timePointsToKeep : A logical vector of length viewGet(vw, 'numFrames')
                % that specifies which time points we want to keep
    % newDtName : name of the new datatype we want to create (newdt)
    % annotation: a string. comments / notes to oneself
   
% OUTPUTS
    % vw        : the updated view

%% Intializing and checking things

mrGlobals;

% Check that the input view is the Inplane!
curViewType = viewGet(vw, 'View Type');
if ~strcmp('Inplane', curViewType)
    error('Must be in Inplane!')
end

% Check that all scans in scanList have the same slices,  numFrames,  cropSizes
checkScans(vw, scanList);

% Check that timePointsToKeep has valid input
% - Check that it is a 1 dim vector
if min(size(timePointsToKeep)) ~= 1
    error('timePointsToKeep must be a 1 dimensional vector!')
end
% Check that the vector has the same number of elements as numFrames
nFrames = viewGet(vw, 'numFrames');
if prod(size(timePointsToKeep)) ~= nFrames
    error('timePointsToKeep must be a vector with length numFrames!')
end

%% create the new datatype
% Open a hidden inplane view 
hiddenView = initHiddenInplane; 

% Set dataTYPES.scanParams so that the new dt has the same params as the
% one being truncated.
% Create in the new datatype as many scans as length(scanList)
% If the new datatype already exists, append scans onto the the datatype
% The scan indices of the newly created ones are stored in newScanNumVec
newScanNumVec = zeros(1, length(scanList)); 
for iScan = 1:length(scanList)
    
    scanInd = scanList(iScan);
    src = {vw.curDataType scanInd};
    
    % this function creates the new dt if it does not already exist
    % [hiddenView, newScanNum, ndataType] = initScan(hiddenView, newDtName, [], src);
    [hiddenView, newScanNum, ndataType] = initScan(hiddenView, newDtName, [], src);
    newScanNumVec(iScan) = newScanNum; 
    
    % set the annotation for this new dt. Do this for each newly created scan. 
    dataTYPES(ndataType) = dtSet(dataTYPES(ndataType), 'Annotation', annotation, newScanNum);
end

% select the new dt
hiddenView = selectDataType(hiddenView, newDtName);

% save the session
saveSession;

%% time series directory
% Get the tSeries directory for this dataType
% (make the directory if it doesn't already exist).
tseriesdir = tSeriesDir(hiddenView);

% Make the Scan subdirectory for the new tSeries (if it doesn't exist)
% Do this for each scan
for iScan = 1:length(scanList)
    scandir = fullfile(tseriesdir, ['Scan', num2str(iScan)]);
    if ~exist(scandir, 'dir')
        mkdir(tseriesdir, ['Scan', num2str(iScan)]);
    end
end


%%  time series 
% Double loop through slices and scans in scanList
nScansToChange = length(scanList);
% *** check that all scans have the same slices
nSlices = length(sliceList(vw, scanList(1)));
tSeriesTruncFull = []; % Initialize

% Get the whole tseries in one read
for iScansToChange=1:nScansToChange
    iScan = scanList(iScansToChange);
    [~, nii] = loadtSeries(vw,  iScan);
    tSeries = double(niftiGet(nii, 'data'));

    dimNum = length(size(tSeries)); % Can handle 2 and 3D tSeries
    
    % TRUNCATE!
    tSeriesTrunc = tSeries(:,:,:,timePointsToKeep);
    
    % not sure why this is concatenating an empty matrix -- perhaps something
    % to do with preserving dimensions?
    tSeriesTruncFull = cat(dimNum + 1, tSeriesTruncFull, tSeriesTrunc); % Combine together

    % reshape to time x pixels x slice
    dims = viewGet(vw, 'data size');
    tSeriesTruncFull = reshape(tSeriesTruncFull, prod(dims(1:2)), dims(3), []);
    tSeriesTruncFull = permute(tSeriesTruncFull, [3 1 2]);

    % % function savetSeries(tSeries,vw,scan,[slice],[nii])
    % this function also creates a nifti with the appropriate time series
    savetSeries(tSeriesTruncFull, hiddenView, iScansToChange);

end

%% update frame information in the new datatype
 

% number of frames
numNewFrames = sum(timePointsToKeep); 
dataTYPES(ndataType) = dtSet(dataTYPES(ndataType), 'nFrames', numNewFrames);

% motion correction information also seems to depend on numFrames
% this information is of size 2 x origNumFrames
tem = dtGet(dataTYPES(ndataType), 'withinscanmotion');
newWithinScanMotion = tem(:,timePointsToKeep);
dataTYPES(ndataType) = dtSet(dataTYPES(ndataType), 'withinscanmotion', newWithinScanMotion);

% save 
saveSession; 

%%
verbose = prefsVerboseCheck;  % only pop up if we prefer it
if verbose
    % This could be displayed more beautifully (turned off msgbox -ras)
    str = sprintf('Averaged tSeries saved with annotation: %s\n', annotation);
    str = [str, sprintf('Data are saved in %s data type\n', newDtName)];
    % msgbox(str);
    disp(str)
end

% Loop through the open views,  switch their curDataType appropriately,
% and update the dataType popups
INPLANE = resetDataTypes(INPLANE, ndataType);
VOLUME  = resetDataTypes(VOLUME, ndataType);
FLAT    = resetDataTypes(FLAT, ndataType);

disp('Done Truncating tSeries.')


end



% /-----------------------------------------------------------/ %
function checkScans(vw, scanList)
%
% Check that all scans in scanList have the same slices,  numFrames,  cropSizes
for iscan = 2:length(scanList)
    if find(sliceList(vw, scanList(1)) ~= sliceList(vw, scanList(iscan)))
        myErrorDlg('Can not average these scans; they have different slices.');
    end
    if (viewGet(vw, 'numFrames', scanList(1)) ~= viewGet(vw, 'numFrames', scanList(iscan)))
        myErrorDlg('Can not average these scans; they have different numFrames.');
    end
    if find(viewGet(vw, 'sliceDims', scanList(1)) ~= viewGet(vw, 'sliceDims', scanList(iscan)))
        myErrorDlg('Can not average these scans; they have different cropSizes.');
    end
end
return;
end
