function ff_alterTSeries(nScale, nMu, nSig, dtNameSource, dirVista)
% ff_alterTSeries(nScale, nMu, nSig, dtNameSource, dirVista)
%% change (add noise, change amplitude) the time series
% timePoint * scale + NOISE(nMu, nSig)
% where NOISE is randomly sampled from a normal distribution with 
% mean nMu and std nSig. 
% and where scale amplifies the signal in either the positive or negative
% direction, depending on where tSeriesPC falls relative to 0.
%% NOTE:
% A percent change of a percent change will result in crazy values 
% (because the mean is centered about 0).
%
% Revisiting this code a year later ... 
% I think this is an issue because mrVista assumes the time series is raw,
% meaning it will attempt to take the percent signal change. If the data
% that we save is already a percent signal change, we will be dividing by 0
% (the mean of the tseries) resulting in values near infinity
%
% To add noise to the real data:
% - convert to pc
% - add the noise
% - add 100 (arbitrary value?)
%
% this type of manipulation to the tSeries (without adding noise) results
% in a difference of 0.00001 to the time series 
% (when using mrVista plotting tseries functions)
%
%% INPUTS
% nScale: scale factor (1 if we don't want amplitude to change)
% nMu: this should be 0.
% nSig: standard deviation
% list_dtNamesSource: names of the datatypes whose tseries serve as the source
%   the newDt will automatically be named with the form:
%   {sourceDt}_scale{nScale}mu{nMu}sig{nSig}
% dirVista: directory with mrSESSION

%% define things //////////////////////////////////////////////////////

% name of the datatype we will be creating
% {sourceDt}_scale{nScale}mu{nMu}sig{nSig}
nScaleString = ff_dec2str(nScale);
nMuString = ff_dec2str(nMu);
nSigString = ff_dec2str(nSig);
dtNameNew = [dtNameSource '_scale' nScaleString 'mu' nMuString 'sig' nSigString];


% MAKE THIS NEW DT
% we will copy the source dt but give it a new name
% this will copy over the time series ... which we will overwrite
chdir(dirVista);
vw = initHiddenGray; 

if ~existDataType(dtNameNew) && existDataType(dtNameSource)

    % set to original dt
    vw = viewSet(vw, 'curdt', dtNameSource);

    % do the copying
    duplicateDataType(vw,dtNameNew);
    
     % somehow this does not rename the dt
    load mrSESSION 
    dt = dataTYPES(end); 
    dt.name = dtNameNew; 

    dataTYPES(end) = dt; 
    saveSession; 
 
end 


% DELETE THE RET MODELS ORIGINALLY IN THIS DT
chdir(fullfile(dirVista, 'Gray', dtNameNew));
eval(['! rm *.mat*']);

% go to where the tseries are stored in this dt
chdir(fullfile(dirVista, 'Gray', dtNameNew, 'TSeries'));

% the number of scans in this datatype
numScans = length(dir) - 2; 

for nn = 1:numScans

    % go to where the scan's tseries are stored
    chdir(['Scan' num2str(nn)]);
    
    
%     % load the variable tSeries
%     % which is numFrames x numCoords
%     if(exist('tSeries1_original.mat'))
%         tmp.tSeries1 = load('tSeries1_original.mat'); 
%     else
%         tmp.tSeries1 = load('tSeries1.mat');     
%     end
    
    tmp.tSeries1 = load('tSeries1.mat'); 



    % save a copy of the original, because we will overwrite the tSeries
    % variable
    tSeries = tmp.tSeries1.tSeries;
    save('tSeries1_original.mat', 'tSeries');
    delete('tSeries1.mat');

    % save a copy as another variable name, then clear it
    tSeries_original = tSeries; 
    clear tSeries; 

    % numTrs
    numTrs = size(tSeries_original,1);

    % numCoords
    numCoords = size(tSeries_original,2);

    % convert to percent signal change
    % This is a number around -1 to 1 percent with the mean removed.
    tSeriesPC = ff_raw2pc(tSeries_original);

    % Create the scale matrix
    matScale = nScale * ones(numTrs, numCoords);

    % Create the normal noise the musig matrix
    matMuSig = normrnd(nMu, nSig, numTrs, numCoords);

    % add noise to the tSeriesPC
    tem = tSeriesPC.* matScale + matMuSig; 
    % add 100 to the noisy tSeriesPC
    tSeries = tem + 100; 

    % save the altered time series
    save('tSeries1.mat', 'tSeries'); 
    


end







