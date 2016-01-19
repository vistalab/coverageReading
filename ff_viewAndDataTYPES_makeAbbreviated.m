Afunction [view, dataTYPES] = ff_viewAndDataTYPES_makeAbbreviated()

%% define a temporary view struct with only certain fields populated
% The rmGridFit function requires a view to be passed in, though it doesn't
% necessarily need ALL the information (eg left mesh)
%
% Stepping through the code, it seems like only the following need to be
% defined:
% view = rmLoadParameters(view)
    % params = rmDefineParameters(vw);
        % THINGS IN THE VIEW TO HAVE DEFINED
        % viewGet(vw, 'numSlices')
        % viewGet(vw, 'dataTypeName')
        % viewGet(vw, 'numScans')
        % view.viewType
        % viewGet(vw,'rmStimParams')
        % view.selectedROI 
        % viewGet(vw,'mmPerVox')
      
    % params = rmMakeStimulus(params);
      
    % view = viewSet(vw, 'rmParams', params);

    
%% fields/information we need - usually based on other information
% define that other information

% view.viewType
view.viewType = 'Gray';

% viewGet(vw, 'curdt')
% the number of the current datatype we are interested in
% since we are making up the tseries this can just be 1
view.curDataType = 1;

% viewGet(vw, 'numSlices') -- the value of this depends on view.viewType
% all good

% viewGet(vw, 'dataTypeName')
% dataTYPES( viewGet(vw, 'curdt') ).name;
dataTYPES(1).name = 'Made up view and datatype';

% viewGet(vw, 'numScans')
% length(dataTYPES(dataType).scanParams);
dataTYPES(1).scanParams = 0;

% viewGet(vw,'rmStimParams')
% Return the retinotopy model stimulus parameters. This is a subset
% of the retinopy model parameters.
%   stimParams = viewGet(vw, 'RM Stimulus Parameters');
%
% params = rmDefineParameters(vw);
% params = rmMakeStimulus(params);

vw.rm.retinotopyParams.stim = params;

% view.selectedROI
view.selectedROI = 1; 

% viewGet(vw,'mmPerVox')
view.mmPerVox = 2;

% view.rm.retinotopyParams -- I think this gets taken care of with
% viewSet(vw, 'rmParams')
% all good


end

