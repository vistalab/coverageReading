function [subjectRmroi, subjectExists] = ff_rmroiForSubject(rmroi, subInitials)
%% checks if rmroi struct has a given subject

subjectExists = false; 
subjectRmroi = []; 

% loop over all subjects in the rmroi
for ii = 1:length(rmroi)
    
    % this rmroi
    rr = rmroi{ii}; 
    
    % if subject has data in the rmroi struct
    if strcmp(rr.subInitials, subInitials)
        
        % return it
        subjectRmroi = rr; 
        subjectExists = true; 
        
    end
   
end

end


