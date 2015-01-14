%% make new dataTYPES that is the aveage of time series

%% modify here
% name of the new dts
listDtNames = {
    'Checkers';
    'Words';
    'FalseFonts';
    };

% epoch numbers that we want to average over for each dt
listEpochNums = {
    [1 4 7];
    [2 6];
    [3 5];
    };

% dt name that we want to average over
dtToAverage = 'MotionComp';


%% no need to modify below this
% define the annotations, which will list the functional run numbers that
% were averaged, as well as the dt that was averaged
listAnnotations = cell(length(listDtNames),1);
for ii = 1:length(listDtNames)
    listAnnotations{ii,1} = {
    ['average of' dtToAverage '. Functional numbers: ' listEpochNums{ii}];
    };
end

% make sure we're in the correct dt
INPLANE{1} = viewSet(INPLANE{1},'curdt',dtToAverage);

% do it in the inplane
for ii = 1:length(listDtNames)
    scanList    = listEpochNums{ii}; 
    typeName    = listDtNames{ii}; 
    annotation  = listAnnotations{ii} ; 
    INPLANE{1} = averageTSeries(INPLANE{1}, scanList, typeName, annotation);
end
