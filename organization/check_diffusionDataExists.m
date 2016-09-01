%% check that subject has diffusion data collected
% prints out subjects WITH diffusion data
bookKeeping; 

%%
hasData = []; 
for ii = 1:length(list_sessionDtiQmri)
    
    if exist(list_sessionDtiQmri{ii})
        hasData = [hasData ii];
    end
    
end

%% display
display('These subjects have diffusion data:')
hasData