function ff_alterTSeriesNoise(nScale, nMu, nSig, list_rmNames, dirVistaAlt)
%% change (add noise, change amplitude) the time series
% timePoint * scale + NOISE(nMu, nSig)
% where NOISE is randomly sampled from a normal distribution with 
% mean nMu and std nSig. 
% and where scale amplifies the signal in either the positive or negative
% direction, depending on where tSeriesPC falls relative to 0.
%% NOTE:
% A percent change of a percent change will result in crazy values 
% (because the mean is centered about 0).
% To add noise to the real data:
% - convert to pc
% - add the noise
% - add 100
%
% this type of manipulation to the tSeries (without adding noise) results
% in a difference of 0.00001 to the time series
%
%% INPUTS
% nScale: scale factor (relative to 0 baseline)
% nMu: this should be 0.
% nSig: standard deviation
% list_rmNames: names of the datatypes whose tseries we want altered. will
% dirVistaAlt: directory that is the copied mrVista session

%% define things //////////////////////////////////////////////////////

% number of rms
numRms = length(list_rmNames);

%%

for kk = 1:numRms
    
    % this rm (datatype)
    rmName = list_rmNames{kk};
    
    % go to where the tseries are stored in this dt
    chdir(fullfile(dirVistaAlt, 'Gray', rmName, 'TSeries'));
    
    % the number of scans in this datatype
    numScans = length(dir) - 2; 
    
    for nn = 1:numScans
        
        % go to where the scan's tseries are stored
        chdir(['Scan' num2str(nn)]);
        
        % load the variable tSeries
        % which is numFrames x numCoords
        load('tSeries1.mat');
        
        % save a copy of the original, as we will overwrite the tSeries
        % variable
        save('tSeries1_original.mat', 'tSeries')
        
        % save a copy as another variable name, then clear it
        tSeries_original = tSeries; 
        clear tSeries; 
        
        % numTrs
        numTrs = size(tSeries_original,1);
        
        % numCoords
        numCoords = size(tSeries_original,2);
        
        % convert to percent signal change
        tSeriesPC = ff_raw2pc(tSeries_original);
        
        % get the scale matrix
        matScale = nScale * ones(numTrs, numCoords);
        
        % get the musig matrix
        matMuSig = normrnd(nMu, nSig, numTrs, numCoords);
        
        % add noise to the tSeriesPC
        tem = tSeriesPC.* matScale + matMuSig; 
        % add 100 to the noisy tSeriesPC
        tSeries = tem + 100; 

        % save the altered time series
        save('tSeries1.mat', 'tSeries'); 
        
        
    end
    
end





