function stimParams = ff_stimParams(stimDescript)
% stimParams = ff_stimParams(stimDescript)
% stimParams = ff_stimParams('knk')
% stimParams = ff_stimParams('checkers')
% 
% returns the stim params. saves time because 99% this is identical across
% subjects.
% 'stimDescript' is a string -- either 'knk' or 'checkers'

% grab the canonical knk stim params
% or the canonical checkerboard stim params

dirVista = '/share/wandell/data/reading_prf/ol/tiledLoc_sizeRet';

switch stimDescript
    case 'knk'
        dtName = 'Words';
        rmName = 'retModel-Words-css.mat';       
    case 'checkers'  
        dtName = 'Checkers';
        rmName = 'retModel-Checkers-css.mat'; 
end

%% 
chdir(dirVista);
vw = initHiddenGray; 
rmPath = fullfile(dirVista, 'Gray', dtName, rmName);
vw = rmSelect(vw, 1, rmPath); 
stimParams = viewGet(vw, 'rmParams'); 

stimParams = rmRecomputeParams(vw, stimParams,[]);

end



