%% s_glmRun
%
% THIS IS NOT THE MOST UPDATED VERSION
%
% Illustrates how to run a GLM on a functional data set.
% Tested 01/04/2011 - MATLAB r2008a, Fedora 12, Current Repos
% Stanford VISTA

%% modify here
% Data directory (where the mrSession file is located)
dirVista    = pwd; 

% You must analyze with the matlab directory in the data directory.
curDir      = pwd;      % We will put you back where you started at the end
chdir(dirVista);

% tr time, in seconds
trTime      = 1; 

% number of trs per block
% 4 if running the 2hz kidLoc
numTrsInBlock = 4;

% There can be several data types - we're using motion compensated dated
dataType = 'MotionComp_RefScan1';

%% Get data structure if it is not already loaded

if  exist('FLAT','var') && ~isempty(FLAT)
    % if mrVista session is already open
    % don't do anything
else
    mrVista('3');
end

%% Prepare scans for GLM

numScans = viewGet(VOLUME{1}, 'numScans');
whichScans = 1:numScans;

% If you're processing your own experiment, you'll need to produce parfiles
% More info @
% http://white.stanford.edu/newIm/index.php/GLM#Create_.par_files_for_each_scan
whichParfs = {'script_kidLoc_2Hz_run1.par' ...
              'script_kidLoc_2Hz_run2.par' ...
              'script_kidLoc_2Hz_run3.par'};

VOLUME{1} = er_assignParfilesToScans(VOLUME{1}, whichScans, whichParfs); % Assign parfiles to scans
VOLUME{1} = er_groupScans(VOLUME{1}, whichScans, [], dataType); % Group scans together

%% Set GLM Parameters:
% The GLM parameters are stored in a Matlab structure.
% We call the structure params.
% The parameters, such as params.timeWindow inform the GLM processing
% routine about the experiment.
% 
% A description of the parameters can be found on the wiki at:
%
% http://white.stanford.edu/newlm/index.php/MrVista_1_conventions#eventAnalysisParams
params.timeWindow               = -8:24;  
params.bslPeriod                = -8:0;    
params.peakPeriod               = 4:14;   
params.framePeriod              = trTime;           % TR
params.normBsl                  = 1;
params.onsetDelta               = 0;
params.snrConds                 = 1;
params.glmHRF                   = 3;                % 3: is spm hrf
params.eventsPerBlock           = numTrsInBlock;    % the number of TRs for which each block lasted
params.ampType                  = 'betas';
params.detrend                  = 1;
params.detrendFrames            = 20;
params.inhomoCorrect            = 1;
params.temporalNormalization    = 0;
params.glmWhiten                = 0;

saveToDataType = 'GLMs'; % Data type the results will be saved to

%% Run GLM:
% Returns view structure and saved-to scan number in new data type
[VOLUME{1}, newScan] = applyGlm(VOLUME{1}, dataType, whichScans, params, saveToDataType);

% newScan indicates the scan # in which results are saved
% VOLUME{1} is a mrVista view structure.  If you just type VOLUME{1}, you will see a lot
% of the fields.  In this case, many of them are empty.  To understand what
% the fields can represent, see the vistalab wiki re: GLMs.

%% END

