%% make the ret template directory in each subject's shared anatomy directory
bookKeeping_rory; 

%%

numSubs = length(list_sub);

for ii = 1:numSubs
    dirAnatomy = list_anatomy{ii};
    chdir(dirAnatomy)
    mkdir('retTemplate')
    
end
    

