
% takes a list of filenames which contain pRF models for each voxel in the
% roi for both groups of subjects
% h is a struct containing various parameters for thresholding and so on
% h.threshecc
% h.threshco
% h.threshsigma
%% load roi.  threshold data.
%% get summary statistics for roi for each group
%% make plot of stat comparisons for each group across rois
%% so 4 sets of box plots

clear all; close all; clc; 

%% modify here

% thresholds on roi and plotting
% optimally, this could be done once but its a lot of working code to fix
% threshold
h.threshco = .2;
h.threshecc = [0 24];
h.threshsigma = [0 24];
h.binsize = 1;
h.minvoxelcount = 10;

% subjects to use
h.subjects1Descrip = 'LUCAS'; % plotting purposes
h.subjects1 = {
    %% LUCAS
    'ak'    % 1
    'amr'   % 2
    'ch'    % 3
    'kh'    % 4
    'kw'    % 5
    'lmp'   % 6
    'ni'    % 7
    'rb'    % 8
    'wg'    % 9
    %% CNI
%     'rl'    % 10
%     'am'    % 11
%     'asr'   % 12
%     'jw'    % 13
    };

h.subjects2Descrip = 'CNI'; % plotting purposes
h.subjects2 = {
    %% LUCAS
%     'ak'    % 1
%     'amr'   % 2
%     'ch'    % 3
%     'kh'    % 4
%     'kw'    % 5
%     'lmp'   % 6
%     'ni'    % 7
%     'rb'    % 8
%     'wg'    % 9
    %% CNI
    'rl'    % 10
    'am'    % 11
    'asr'   % 12
    'jw'    % 13
    };

% rois %*
% these need to appear as matched triplets
% control data      RMgroup2 data        roiname
rois = {

    'leftVWFA';  
    'rightVWFA';
    'CbothVWFA';

%     'left_wordVscramble_all';
%     'left_wordVscramble_restrict';
%     'right_wordVscramble_all';
%     'right_wordVscramble_restrict';
%     'CwordVscramble_all';
%     'CwordVscramble_restrict';

%     'LV1';
%     'LV2d';
%     'LV2v';
%     'LV3d';
%     'LV3v';
%     'LV3ab';
%     'LhV4';
%     'LVO-1';
%     'LVO-2';
%     'LTO-1';
%     'LTO-2';
%     'LIPS-0'; 

%     'RV1';
%     'RV2d';
%     'RV2v';
%     'RV3d';
%     'RV3v';
%     'RV3ab';
%     'RhV4';
%     'RVO-1';
%     'RVO-2';
%     'RTO-1';
%     'RTO-2';
%     'RIPS-0';

    'CV1';
    'CV2d';
    'CV2v';
    'CV3d';
    'CV3v';
%     'CV3ab';
%     'ChV4';
%     'CVO-1';
%     'CVO-2';
%     'CTO-1';
%     'CTO-2';
%     'CIPS-0';   
    };

% font size for figures because computer settings
axisFontSize = 20; 

%% minimal modifying here
% directory with code
dirCode = '/biac4/kgs/biac3/kgs4/projects/retinotopy/adult_ecc_karen/Analyses/pRF2sel/';
addpath(dirCode);

% directory with the RM structs
dirData = '/biac4/wandell/data/reading_prf/forAnalysis/structs/'; 

% string recording the thresholds
threshstring =  ['co' num2str(h.threshco) ...
    '.ecc' num2str(h.threshecc(1)) '_' num2str(h.threshecc(2)) '.sig' ...
    num2str(h.threshsigma(1)) '_' num2str(h.threshsigma(2)) '/'];

% save directory
h.dirSave   = ['/biac4/wandell/data/reading_prf/forAnalysis/images/group/stats/' threshstring];

% concatenate the roi names in the order used
figname     = reshape(char(rois(:))',1,[]);
% remove spaces
figname     = regexprep(figname,' ','');

% check for save directory
if ~exist(h.dirSave ,'dir')
    mkdir(h.dirSave)
end

% variables to store model fits
legendnames = {};
modelfits   = [];

% initialize space
group1Medians = cell(1,length(rois)); 
group2Medians = cell(1,length(rois)); 
stats         = cell(1,length(rois)); 

% for each roi
for r = 1:length(rois)
    
    % load RM struct 
    load([dirData 'RM_' char(rois(r)) '.mat']);

    
    % get only the sessions you want to use
    % get only subjects we are interested in
    % find index to rms we want to keep
    % still editing this part
    
    rmindex1 = [];
    % for each rm in RM
    for m = 1:length(RM)
        
        % check for matching session name
        for s = 1:length(h.subjects1)
            
            % if it matches add rm to rmindex1
            if strcmp(h.subjects1(s),RM{m}.subject)
                rmindex1 = [rmindex1 m];
            end
        end 
    end

    % get subset of subjects and their thresholded data
    RMgroup1    = RM(rmindex1);
    th_RMgroup1 = f_thresholdRMData(RMgroup1,h);
    
    % do the same for the RMgroup2
    rmindex2 = [];
    
    % for each rm in RM
    for m = 1:length(RM)
        
        % check for matching session name
        for s = 1:length(h.subjects2)
            
            % if it maches, add rm to rmindex2
            if strcmp(h.subjects2(s), RM{m}.subject)
                rmindex2 = [rmindex2 m];
            end
        end
    end

    % get subset of subjects and their thresholded data
    RMgroup2    = RM(rmindex2); 
    th_RMgroup2 = f_thresholdRMData(RMgroup2,h);
    
    
    % get the stats here
    [group1Medians{r}, group2Medians{r}, stats{r}] = f_plotAllROIStats(th_RMgroup1, th_RMgroup2, h);
    % change some properties, like where the plot is positioned on the
    % screen and font sizes
    set(gcf, 'Position','default');
    hxlab = get(gca,'XLabel');
    hylab = get(gca,'YLabel');
    set(hxlab,'FontSize', axisFontSize); 
    set(hylab,'FontSize', axisFontSize); 
    
    % clear variables
    clear RMgroup1 RMgroup2 th_RMgroup1 th_RMgroup2
end


% figname with rois include
figname=reshape(char(rois(:))',1,[]);
% remove spaces
figname=regexprep(figname,' ','');

%
fldname = 'size';
ff_makeBoxPlotsAcrossROIsCvsP(h,rois,group1Medians,group2Medians,stats,fldname);
    set(gcf, 'Position','default');
    hxlab = get(gca,'XLabel');
    hylab = get(gca,'YLabel');
    set(hxlab,'FontSize', axisFontSize); 
    set(hylab,'FontSize', axisFontSize); 
saveas(gcf,[h.dirSave fldname '.' figname '.png'],'png');

fldname = 'co';
ff_makeBoxPlotsAcrossROIsCvsP(h,rois,group1Medians,group2Medians,stats,fldname);
    set(gcf, 'Position','default');
    hxlab = get(gca,'XLabel');
    hylab = get(gca,'YLabel');
    set(hxlab,'FontSize', axisFontSize); 
    set(hylab,'FontSize', axisFontSize); 
saveas(gcf,[h.dirSave fldname '.' figname '.png'],'png');

fldname = 'ecc';
ff_makeBoxPlotsAcrossROIsCvsP(h,rois,group1Medians,group2Medians,stats,fldname);
    set(gcf, 'Position','default');
    hxlab = get(gca,'XLabel');
    hylab = get(gca,'YLabel');
    set(hxlab,'FontSize', axisFontSize); 
    set(hylab,'FontSize', axisFontSize); 
saveas(gcf,[h.dirSave fldname '.' figname '.png'],'png');

fldname = 'sigma';
ff_makeBoxPlotsAcrossROIsCvsP(h,rois,group1Medians,group2Medians,stats,fldname)
    set(gcf, 'Position','default');
    hxlab = get(gca,'XLabel');
    hylab = get(gca,'YLabel');
    set(hxlab,'FontSize', axisFontSize); 
    set(hylab,'FontSize', axisFontSize); 
saveas(gcf,[h.dirSave fldname '.' figname '.png'],'png');


% should also output a table with real numbers in it
% columns are rois
% rows are subjects plus a median and standard deviation








