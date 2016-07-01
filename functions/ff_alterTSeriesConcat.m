function tSeries = ff_alterTSeriesConcat(numTimesToConcat, dirVistaAlt, dtName)
% tSeries = ff_alterTSeriesConcat(numTimesToConcat, dirVistaAlt, rmName);
%
%% Concatenates time series
% ASSUMPTIONS
% - The tSeries is already xformed in the gray
% - There is only one scan in the gray
% Raw tseries may vary widely between runs. 
% Thus we will convert to percent signal change before doing any
% manipulation, and then add 100. This is because the rm code assumes the
% time series it is grabbing is raw, and a percent signal change of a
% percent signal change results in large values because of division by 0 (the mean)
%
% INPUTS
% numTimesToConcat  : number of times to concatenate. usually 2
% dirVistaAlt       : the directory of the vista session we want to change
% rmName            : the datatype whose time series we want to change
%
% OUTPUTS
% tSeries           : the concatenated time series
%% -----------------------------------------------------------------------

% go to where the tseries are stored in this dt
chdir(fullfile(dirVistaAlt, 'Gray', dtName, 'TSeries'));

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
    
    % DO THE CONCATENATION
    tSeries = repmat(tSeriesPC, 1, numTimesToConcat); 
    
    % save the altered time series
    save('tSeries1.mat', 'tSeries'); 
    
    
end





end