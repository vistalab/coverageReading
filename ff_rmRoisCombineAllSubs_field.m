function SScomb = ff_rmRoisCombineAllSubs_field(SS,nameOfField)

%% all voxels across subjects
% for a given parameter (eg, varExplained, ecc ...) loops through the
% columns of SS to 
% retains the dimensions of SS. So for example if SS has multiple rows
% corresponding to different conditions and mulitple columns corresponding 
% to different rois, SScomb will also have these same
% dimensions, i.e. it will combine accordingly
% INPUTS:
% 1. SS a 1 x numsubjects struct
% 2. nameOfField: a string. the parameter name that we want to combine over. can be one of the
% following:
%          co
%      sigma1
%      sigma2
%        beta
%          x0
%          y0
%          ph 
%         ecc 

numSubs     = size(SS,2);
numConds    = size(SS{1},1); 
numRois     = size(SS{1},2); 
SScomb      = cell(1,numRois); 


for kk = 1:numConds
    for jj = 1:numRois
        
        temall = []; 
        for ii = 1:numSubs
    
        % grab the element
        tem  = SS{ii}{kk,jj}; 
        
        % if it is not empty, append
        if ~isempty(tem)
            temField    = eval(['tem.' nameOfField]); 
        % if it is empty, append the empty matrix
        else
            temField 	= []; 
        end
        temall = [temall, temField]; 

        end
        
        SScomb{kk,jj} = temall; 
    end
end


end

