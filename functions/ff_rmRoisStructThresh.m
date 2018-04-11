function Sth = ff_rmRoisStructThresh(S, h)
error('outdated function ... USE ff_thresholdRMData'); 
% thresholds S by values specified in h
% S can be 3 dimensional or less
% INPUTS:
% 1. S
% 2. h: contains the fields that we want to threshold by
% 
% OUTPUTS:
% 1. Sth: thresholded S

Sth = cell(size(S)); 

dim1 = size(S,1); 
dim2 = size(S,2);
dim3 = size(S,3); 

for ii = 1:dim1
    for jj = 1:dim2
        for kk = 1:dim3
            
            % grab the appropriate element
            s = S(ii,jj,kk); 
            
            % threshold it
            sth = ff_thresholdRMData(s,h); 
            
            Sth{ii,jj,kk} = sth{1}; 
            
        end
    end
end



end