%% Behaviorally plot and calculate some correlations between phonological 
% awareness and reading performance
% Some assumptions made. 
% That we will collapse over 4 years. for a particular test

clear all; close all; clc; 

%% read in the file and store data

% behavioral file
fLoc = '/sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview/';
fName = 'read_behav_measures_longitude.xls';
fPath = fullfile(fLoc, fName);

% % where to save the plots
dirSave = '/sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview/figures';

%% do the things
% num is a 55 x 145 matrix
% each row is a subject
% each column is a behavioral test
[temscores,txt,raw] = xlsread(fPath);

% temnum currently has the first column but not the first row!!
% of the xls sheet (first col = subject code as all nans)
% we want it to be all numerical, so kill this first column
% num is 55 x 144
scores = temscores(:, 2:145);

% get the subject code
% subCode is a 55 x 1 cell
subCode = txt(2:56,1);

% get the name of the test
% test code is a 144 x 1 cell
testCode = txt(1,2:145);
numTests = length(testCode); 

% corresponding to the 4 years
% list_markers = {'o', 's', 'd', '^'};
list_markers = {'s', 's', 's', 's'};

% the X axis. CTOPP scores
list_yearIndsXAxis = [14, 49, 83, 117]; 

% the Y axis. Reading ability scores
% test indices corresponding to the 4 years
% Word ID ss -- 37, 71, 105, 139
% GORT -- 26, 61, 95, 129
% TOWRE Composite -- 30, 65, 99, 133
% Passage Comprehension -- 41, 75, 109, 143 
% Subject's testsing age -- 5, 43, 77, 111
list_yearIndsYAxis = [37, 71, 105, 139]; 

% the age at testing
list_yearIndsAge = [5, 43, 77, 111];

testName  = 'WORD ID'; 

% colors correspond to the year
list_colors = [
    [.8 .7 .1]
    [.2 .7 .8]
    [.1 .5 .1]
    [.3 0 .9]
    ];

%% In which we figure out the index for the test. Which index for which test?
% Which columns have Word ID data?
% find(strcmp('Word ID ss.1',testCode))
% find(strcmp('Word ID ss.2',testCode))
% find(strcmp('Word ID ss.3',testCode))
% find(strcmp('Word ID ss.4',testCode))
% : 37, 71, 105, 139

% The columns that have GORT data
% 26, 61, 95, 129

% The columns that have the TOWRE Composite
% 30, 65, 99, 133

% The columns that have Passage comprehension
% 41, 75, 109, 143 

% The columns that have testing age
% 5, 43, 77, 111


%% This is the plot I want to make. will make 3 plots
% x axis will be CTOPP phonological score. 
% y axis will be reading performance evaluation
% Each point in the plot will correspond to a subject at a particular year
% The color of the dot will correspond to the subject
% The shape of the dot will correspond to the year

close all; 
figure; hold on; 
grid on; 

xDataConcat = []; 
yDataConcat = []; 
ageDataConcat = []; 

% loop over the years
for yy = 1:4
    
    % doubly code for now?
    markerShape = list_markers{yy}; 
    markerColor = list_colors(yy,:); 
    
    indXData = list_yearIndsXAxis(yy); % phonological score at given year
    indYData = list_yearIndsYAxis(yy); % reading ability at given year
    indAgeData = list_yearIndsAge(yy); % age at wave of testing
    
    xData = scores(:,indXData); 
    yData = scores(:, indYData); 
    ageData = scores(:, indAgeData);
    
    % take out subjects who may have nans in either x or y
    temXinds = find(~isnan(xData)); % indices that are NOT nans in the x data
    temYinds = find(~isnan(yData)); % indices that are NOT nans in the y
    useIndData = intersect(temXinds, temYinds);
    
    yDataUse = yData(useIndData);
    xDataUse = xData(useIndData); 
    ageDataUse = ageData(useIndData);
    
    markerSize = 150; 
    scatter(xDataUse, yDataUse, markerSize, ageDataUse, 'filled', ...
        'MarkerEdgeColor', [1 1 1], 'Linewidth', 1.5)
    colormap parula
    
%     plot(xDataUse, yDataUse, markerShape, 'markerSize', 12, ...
%         'markerFaceColor', markerColor, 'markerEdgeColor', [1 1 1])
    
    % concatenate over the years so we cann have a correlation line
    xDataConcat = [xDataConcat; xDataUse];
    yDataConcat = [yDataConcat; yDataUse];
    ageDataConcat = [ageDataConcat; ageDataUse];
    
end

% plot correlation line over all the years
% need non nan data to do it
coeffs = polyfit(xDataConcat, yDataConcat,1);
xlims = get(gca, 'XLim');     
fittedX = linspace(xlims(1), xlims(2)); 
fittedY = polyval(coeffs, fittedX);
hold on; 
plot(fittedX, fittedY, 'LineWidth', 3, 'Color', [.7 .6 .6], 'LineWidth',4)

% save the rho value to the title
rho = corr(xDataConcat, yDataConcat);
title(['rho: ' num2str(rho)], 'fontweight', 'bold')

% axis labels
xlabel('CTOPP', 'fontweight', 'bold')
ylabel(testName, 'fontweight', 'bold')

% legend for coloring by waves
% legend({'Year 1', 'Year 2', 'Year 3', 'Year 4'})

% legend for coloring by age


