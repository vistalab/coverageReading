%% Quantitative (MTV/PD) plots of tracts related to reading
% Glam it up. 
clear all; close all; clc; 

%% modify here

% see rr_qMRI_notes for the full list
%     'Left ILF'      % 13
%     'Left SLF'      % 15
%     'Left Arcuate'  % 19
list_tractNums = [13 15 19];

% for now: list of field names in afq.vals that we want to loop through
list_fieldNames = {
    'T1_map_Wlin_2DTI'
%     'TV_map_2DTI'
    };

% remove these subjects from the mean and std.
% 14, 32,and 87 is bad data
% 5 could be for illustrative purposes
list_badInds = [14, 32, 87]; 

% example subject to plot
subEx = 5; 


%%  load the afq struct. a variable called <afq>
pathStruct = '/sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview/afq_06-Apr-2016_prob_masked_withNorms.mat';
load(pathStruct)

%% indices of subjects with good data
goodInds_tem = ones(100,1); 
goodInds_tem(list_badInds) = 0;
goodInds = find(goodInds_tem);

% number of good subjects
numSubs = length(goodInds); 

%%  loop over the tracts
for jj = list_tractNums
    
    fgName = afq.fgnames{jj}; 
    
    %% loop over the fields in afq.vals
    for ff = 1:length(list_fieldNames)
        fieldname = list_fieldNames{ff};
     
        % 100 x 100 matrix for the specific tract
        % Each row is a subject.
        % Each column is a node.
        % Each tract is split into 100 nodes.
        nodes_tem = eval(['afq.vals.' fieldname '{jj}']);
        
        % remove the bad data  
        nodes = nodes_tem(goodInds,:); 
        
        % example subject data
        nodes_sub = nodes_tem(subEx,:); 
           
        %% statistics
        % get the mean value across all good subjects
        meanTract = mean(nodes,1); 
        
        % get the std of the mean value across all good subjects
        stdTract = std(nodes,[],1); 
        
        %% plotting
        figure; hold on; 
        
        % plot the mean tract
        xpoints = [1:100]'; 
        plot(xpoints, meanTract, '-', 'LineWidth', 3, 'Color', [0 .1 .3])
        
        % plot the standard deviation
        fill([xpoints; flipud(xpoints)], ...
            [meanTract' - 2*stdTract'; flipud(meanTract' + 2*stdTract')], ...
            [0.2 .6 .8], 'LineStyle', 'none')
        alpha(0.5); 
        
        % plot a subject that is unlike the controls
        plot(xpoints, nodes_sub, 'Color', [.6 0 .4], 'Linewidth',2)
        
        grid on
        set(gca, 'fontsize', 18, 'fontweight', 'bold')
        set(gcf,'Color','w')
        xlabel('Node number', 'fontsize', 18, 'fontweight', 'bold')
        ylabel(fieldname, 'fontsize', 18, 'fontweight', 'bold')
        titleName = {
            fgName
            fieldname
            };
        title(titleName, 'fontweight', 'bold')
        
    end
 
end

