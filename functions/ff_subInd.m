function subInd = ff_subInd(initials)
% given initials, returns subject index
% given index, returns initials .. TODO

bookKeeping; 
subInd = 'subject not found'; 

curdir = pwd; 

% if a string
if ischar(initials)
    for ii = 1:length(list_sub)

        thisSubInitials = list_sub{ii}; 
        if strcmp(initials,thisSubInitials)
            subInd = ii; 
        end
    end
end
    
% if a number
if isnumeric(initials)
    % check that index is shorter than or equal to bookKeeping list
    if initials < length(list_sub) + 1
        subInd = list_sub{initials};
    else
        display('Check subject number')
    end
end

chdir(curdir);


end