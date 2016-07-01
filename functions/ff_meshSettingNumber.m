
function theSetting = ff_meshSettingNumber(msh, meshView)

% load the settings file, or throw an error if it does nto exist
settingsFile = fullfile(fileparts(msh.path),'MeshSettings.mat'); 
if ~exist(settingsFile,'file')
    error('Sorry you must save some settings to the mesh first!')
end
load(settingsFile, 'settings');

% find the setting number corresponding to the view we want
numSettings = size(settings,2);
wSetting = 0; 
for ss = 1:numSettings

    if(strcmp(meshView, settings(ss).name))
        wSetting = ss; 
    end
end

% if we go into this if statement, no settings saved
if wSetting == 0
    error(['Needs a mesh view called: ' meshView]);
end

theSetting = settings(wSetting); 

end