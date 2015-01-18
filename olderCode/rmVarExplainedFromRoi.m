%% interested in the variance explained for different retinotopic models 
% (because they have different stimuli)
% this script plots the variance explained as a histogram

clear all; close all; clc; 
%% modify here

% directory of roi
dirRoiShared = '/biac4/kgs/biac2/kgs/3Danat/lior/ROIs/'; 

% the rois we're interested in
list_roiNames = {
    'rh_VWFA1_WordNumber_FastLocs_GrandGLM2';
    'lh_VWFA1_WordNumber_FastLocs_GrandGLM2';

    'RH_V1_lb'; 
    'RH_V2d_lb';
    'RH_V2v_lb'; 
    'RH_V3d_lb'; 
    'RH_V3v_lb'; 
    
    'LH_V1_lb'; 
    'LH_V2d_lb';
    'LH_V2v_lb'; 
    'LH_V3d_lb'; 
    'LH_V3v_lb'; 
    
    };

% session with mrSESSION.mat file. all the rm files should be imported here. 
list_session = '/biac4/wandell/data/reading_prf/lb/20141113_1625/'; 


% short description, useful for plotting later
list_comments = {
    'word ret. just fixate. 12 deg. 2 runs'; 
    'word ret. reading. 12 deg. 2 runs';
    'checker ret. just fixate. 6 deg. 4 runs';
    };

% list of the corresponding rm files paths
list_rmFiles = {
    '/biac4/wandell/data/reading_prf/lb/20141113_1625/Gray/wordRet/retModel-20141114-024227-fFit.mat'; 
    '/biac4/wandell/data/reading_prf/lb/20141113_1625/Gray/wordRetRead/retModel-20141114-044840-fFit.mat';
    '/biac4/wandell/data/reading_prf/lb/20141113_1625/Gray/Original/rmImported_retModel-20131107-165954-fFit.mat'; 
    };

% format that we want the to save visualizations as: 'fig' or 'png'
saveFormat = 'png'; 

%% do it!

% turn off text interpreters so that plot titles are cleaner
set(0,'DefaultTextInterpreter','none'); 

chdir(list_session)
S_varExpRoi = cell(length(list_rmFiles), length(list_roiNames)); 

for ii = 1:length(list_rmFiles)
    
    % (re)open mrVista
    vw = mrVista('3'); 
    
    % load the retintopic model
    vw = rmSelect(vw,1,list_rmFiles{ii}); 
    vw = rmLoadDefault(vw); 
    
    for jj = 1:length(list_roiNames)

        % load the rois (automatically selects the one that is just loaded)
        vw = loadROI(vw, [dirRoiShared list_roiNames{jj}], [],[],1,0); 
        
        % get the indices of the roi
        roiInds = viewGet(vw,'roiInds'); 
        
        % rm files store rawrss and rss and compute when needed, according to the formula
        % variance explained = 1 - (model_rss ./ raw_rss).
        % get model_rss and raw_rss from vw.rm
        rss     =  vw.rm.retinotopyModels{1}.rss; 
        rawrss  =  vw.rm.retinotopyModels{1}.rawrss; 
        varExp  = 1 - (rss ./ rawrss);
        
        % variance explained: grab the values
        varExpRoi           = varExp(roiInds); 
        S_varExpRoi{ii,jj}  = varExpRoi;  
        
    end

    close all; 
end

%% plotting variance on both axes

modelx = 3;
modely = 2; 

for ii = 1:length(list_roiNames)
    
    figure();
    plot(S_varExpRoi{modelx,ii}, S_varExpRoi{modely, ii}, '.')
    title(['Variance Explained for voxels in ' list_roiNames{ii}], 'FontSize', 16); 
    xlabel(list_comments{modelx},'FontSize',16);
    ylabel(list_comments{modely},'FontSize',16);
    set(gca, 'XLim', [0 1] ); 
    set(gca, 'YLim', [0 1] );
    identityLine; 
    saveas(gcf,['~/Desktop/' [list_roiNames{ii}] '.' num2str(saveFormat)], num2str(saveFormat))
    
end




