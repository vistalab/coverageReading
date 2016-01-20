function strNew = ff_stringRemove(strOrig, strRemove)
% 
% ex: ff_stringRemove('LV1_rl-Words-css', '_rl') will return 'LV1-Words-css'
%%

% length of string to remove
lenRemove = length(strRemove); 

% index 
i = regexp(strOrig, strRemove, 'once'); 

% new string
strNew = strOrig; 

% if the expression exists in the original string
if ~isempty(i)
    strNew(i:i+lenRemove-1) = []; 
end

end