clear all; close all; clc; 

%% load roi.  threshold data.  bootstrap line fit for each roi.  make plot.
% should produce plots similar to those in Kendrick's jneurophys paper

% important parameters: rois, h
% takes a list of filenames which contain pRF models for each voxel in the
% roi for a group of subjects
% h is a struct containing various parameters for thresholding and so on
% h.threshecc
% h.threshco
% h.threshsigma

%%  modify here

% thresholds on roi and plotting
h.threshco = 0.15;
h.threshecc = [0.5 10];
h.threshsigma = [0 24];
h.binsize = 1;
h.minvoxelcount = 5;

% subjects to use
h.subjects = {
    % LUCAS
    'ak'    % 1
    'amr'   % 2
    'ch'    % 3
    'kh'    % 4
    'kw'    % 5
    'lmp'   % 6
    'ni'    % 7
    'rb'    % 8
    'wg'    % 9
    % CNI
    'rl'    % 10
    'am'    % 11
    'asr'   % 12
    'jw'    % 13
    };

% list of rois
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

%     'CV1';
%     'CV2d';
%     'CV2v';
%     'CV3d';
%     'CV3v';
%     'CV3ab;
%     'ChV4';
%     'CVO-1';
%     'CVO-2';
%     'CTO-1';
%     'CTO-2';
%     'CIPS-0';   
    };


% colors for plot
pcolors = [
    0 0 0; 
    .8 .8 .8; 
    .7 .7 .7;  
    1 0 0;  
    .8 0 0;  
    .5 1 1;  
    1 0 1;  
    .8 0 .8;    
    1 0 0;  
%     0 1 0;  
%     0 0 1;  
%     0 0 0;
    ];


% font size (settings change per computer)
tem.fontSize = 20; 

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
h.dirSave   = ['/biac4/wandell/data/reading_prf/forAnalysis/images/group/sizeVecc/' threshstring];

% concatenate the roi names in the order used
figname     = reshape(char(rois(:))',1,[]);
% remove spaces
figname     = regexprep(figname,' ','');

% check for save directory
if ~exist(h.dirSave ,'dir')
    mkdir(h.dirSave)
end

% variables to store model fits
legendnames     = {};
modelfits       = [];

% for each roi
for r = 1:length(rois)
    
    % load roi RM
    load([dirData 'RM_' rois{r}]); 
    
    % get only the subjects you want to use
    % get only subjects we are interested in
    % find index to rms we want to keep
    % still editing this part
    
    rmindex = [];
    
    % for each rm
    for m = 1:length(RM)
        
        % check for matching subject name
        for s = 1:length(h.subjects)
            
            % if it matches, add rm to sbindx
            if strcmp(h.subjects(s),RM{m}.subject) 
                rmindex = [rmindex m];
            end  
        end   
    end
    
    % rm is a truncated version of RM with specified subjects
    rm = RM(rmindex);
    
    % threshold data
    th_rm = ff_thresholdRMData(rm,h);
    
    % bootstrap line fit
    [th_rm models{r}] = f_sizeVSeccFromROIGroupOnly(th_rm, h);
    
    % delete unnecessary
    clear rm th_rm
    
    % add a name to the models
    models{r}.roiname = rois(r);
    legendnames(r)=rois(r);
    
end


% make our plot
figure('Name','ecc x size across areas','Color',[1 1 1],...
    'Position',get(0,'ScreenSize'));
hold on



xvals = h.threshecc(1):.1:h.threshecc(2);   % x-values to evaluate the model at

for r=1:length(models)
    %     get percentiles
    modelfit = prctile(models{r}.submodelfit,[17 50 83]);
    %     % define a polygon by following the 2.5th percentile line (left to right)
    %     % and then reversing and following the 97.5th percentile line (right to
    %     % left).
    h2(r) = patch([xvals fliplr(xvals)],[modelfit(1,:) fliplr(modelfit(3,:))],pcolors(r,:));
    set(h2(r),'EdgeColor','none','FaceAlpha',.5);
    
    h3(r) = plot(xvals,modelfit(2,:),'LineWidth',2,'Color',pcolors(r,:));
end


% add x = y line

plot(xvals,xvals,'k--');

% legend and plot stuff
legend(h3,legendnames,'Location','EastOutside','FontSize',tem.fontSize);
legend boxoff;

xlabel('eccentricity of pRF center in degrees','FontSize',tem.fontSize);
ylabel('size of pRF in degrees','FontSize',tem.fontSize);

% put a title on it that is ugly but useful
title([threshstring '   ' figname], 'FontSize', tem.fontSize);


% save the figure

saveas(gcf,[h.dirSave figname num2str(h.binsize)  'bins.sizeVecc.png'],'png');

