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
        
        % the beta parameter is a special case
        % possible cases: 1xnumCoords, numCoordsx1, numTrendsxnumCoords,
        % numCoordsxnumTrends
        % the first dimension is always the gain (amplitude)
        % we can figure out by the dimensions which values are gain
        if strcmp(nameOfField, 'beta') && ~isempty(temField)
            % number of coordinate points
            numCoords = (size(tem.x0,2)); 
            
            % the beta weights are either along the first row or along the
            % first column. figure out which.
            if size(tem.beta,1) == numCoords 
                % betas are in a column, must transpose
                temField = tem.beta(:,1)'; 
            end
            if size(tem.beta,2) == numCoords 
                % no need to transpose, just grab first row
                temField = tem.beta(1,:); 
            end
        end
        
        temall = [temall, temField]; 

        end
        
        SScomb{kk,jj} = temall; 
    end
end


end

