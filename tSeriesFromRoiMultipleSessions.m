%% for a given roi, this script will plot the mean tSeries from multiple sessions
% In particular, this may be helpful in determining the stype of stimuli
% that drives signal in the ROI 

clear all; clc; close all; 
%% modify here

% directory of roi
dirRoiShared = '/biac4/wandell/data/anatomy/rosemary/ROIs/'; 

% the rois we're interested in
list_roiNames = {
    'leftVWFA'
    'rightVWFA'
    };

% list of sessions
list_sessions = {
    '/biac4/wandell/data/reading_prf/rosemary/20140425_version2';
    '/biac4/wandell/data/reading_prf/rosemary/20140507_0842';
    '/biac4/wandell/data/reading_prf/rosemary/20140818_1211'
    '/biac4/wandell/data/reading_prf/rosemary/20141026_1148/';
    };


% there should be a dataTYPE in each session that is the average of the
% scans we want. list that dataTYPE number here
list_dtname = {
    'AllBarsAverages';
    'AveragesBars'; 
    'AveragesBars'; 
    'WordRetinotopy';
    }; 

% what type of stimuli in each session
list_comments = {
    'conglomeration bars 2 runs';
    'checker bars 3 runs'; 
    'checker bars 4 runs'; 
    'word retinotopy 2 runs';
    };


%% do work

% initialize for mean tseries
s_tseriesMean = cell(length(list_sessions), length(list_roiNames)); 

% for each session
for ii = 1:length(list_sessions)
    
    % navigate to session and get current gray view
    cd(list_sessions{ii})
    vw = mrVista('3');
    
    % set the correct datatype
    vw = viewSet(vw, 'CurrentDataType', list_dtname{ii}); 
    
    % for each roi
    for jj = 1:length(list_roiNames)
        % load the roi (which automatically selects it)
        vw = loadROI(vw, [dirRoiShared list_roiNames{jj}], [],[],1,0); 
        
        % get the roi coords
        roiCoords = viewGet(vw, 'roi coords'); 
        
        % get the time series of this roi. tSeriesRoi will be a 1x1 struct. 
        % contents will be a matrix of timepoints x numvoxels
        tSeriesRoi = getTseriesOneROI(vw, roiCoords); 
        
        % average time series across all voxels
        tSeriesRoiMean = mean(tSeriesRoi{1}(:,:),2);
        % save mean tseries
        s_tseriesMean{ii,jj} = tSeriesRoiMean; 
        
        %% plot the mean time series
        figure(); 
        plot(tSeriesRoiMean);
        xlabel('Frames')
        ylabel('Percent Modulation')
        title([list_roiNames{jj} ' mean tSeries: ' list_comments{ii}])
        saveas(gcf,['~/Pictures/' 'session' num2str(ii) '_roi' num2str(jj)],'png')
    end
    
    close all; 
end


%% an overlay of the tSeries
% the 1st and 4th sessions have the same number of frames
% the 2nd and 3rd have the same number of frames

%% overlay 1st and 4th
for jj = 1:length(list_roiNames)
    
    figure(); 
    plot(s_tseriesMean{1,jj},'k')
    hold on
    plot(s_tseriesMean{4,jj})
    hold off
    title([list_roiNames{jj} ' mean tSeries'])
    legend(list_comments{1},list_comments{4})
    xlabel('Frames')
    ylabel('Percent Modulation')
    grid on
    
    saveas(gcf, ['~/Pictures/overlay144frames_roi' num2str(jj)], 'png')
end

%% overlay 2nd and 3rd
for jj = 1:length(list_roiNames)
    
    figure(); 
    plot(s_tseriesMean{2,jj},'k')
    hold on
    plot(s_tseriesMean{3,jj})
    hold off
    title([list_roiNames{jj} ' mean tSeries'])
    legend(list_comments{2},list_comments{3})
    xlabel('Frames')
    ylabel('Percent Modulation')
    grid on
    
    saveas(gcf, ['~/Pictures/overlay96frames_roi' num2str(jj)], 'png')
    
end




