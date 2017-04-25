%% Quantitative (MTV/PD) plots of tracts related to reading
% To get a sense of the data
clear all; 
bookKeeping_colors;
close all; clc; 

%% modify here

% see rr_qMRI_notes for the full list
%     'Left ILF'      % 13
%     'Left SLF'      % 15
%     'Left Arcuate'  % 19
list_tractNums = [13 15 19];

% colors for each subject
list_colors = list_colorsWHSubjects; 

% for now: list of field names in afq.vals that we want to loop through
%     T1_map_Wlin_2DTI: 
%         VIP_map_2DTI: 
%          TV_map_2DTI: 
%         SIR_map_2DTI: 
%          WF_map_2DTI: 
list_fieldNames = {
    'T1_map_Wlin_2DTI'
    'TV_map_2DTI'
    };


%%  load the afq struct. a variable called <afq>
pathStruct = '/sni-storage/wandell/data/reading_prf/coverageReading/forReadingReview/afq_06-Apr-2016_prob_masked_withNorms.mat';
load(pathStruct)

%% afq.vals.TV_map2DTI
close all; 

for jj = list_tractNums
    
    fgName = afq.fgnames{jj}; 
    
    %% loop over the fields in afq.vals
    for ff = 1:length(list_fieldNames)
        fieldname = list_fieldNames{ff};
     
        % 100 x 100 matrix for the specific tract
        % Each row is a subject.
        % Each column is a node.
        % Each tract is split into 100 nodes.
        % nodes = afq.vals.TV_map_2DTI{jj};
        nodes = eval(['afq.vals.' fieldname '{jj}']);
              
        %% loop over the subjects 
        figure; hold on; 
        % initialize handles and subIDs
        h = zeros(1,100);
        hsubID = cell(1,100); 
        
        for ii = 1:100
            subColor = list_colors(ii,:); 
            h(ii) = plot(1:100, nodes(ii,:), '.', 'color', subColor);
            hsubID{ii} = num2str(afq.metadata.WH_ID(ii)); 
        end

        set(gcf, 'Color', 'white')
        grid on
        xlabel('Distance along tract')
        
        titleName = {
            fgName;
            fieldname;
            };
        title(titleName, 'fontweight', 'bold')
        
        % legend
        % according to afq.sub_group everyone is a control
        % legend(h, hsubID)
        
    end
 
end

