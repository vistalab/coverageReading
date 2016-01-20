function [vw, ROI] = ff_temROIStructFromCoords(vw, coords)
%% given coordinates, make a temporary roi struct 
% assumes that a volume (NOT hidden) is already loaded
% ie that the variable VOLUME exists

% make the roi struct
ROI.color       = 'm';          % color. default to this for now.
ROI.coords      = coords;       % coords. debug tip:  check transpose
ROI.name        = 'ROI_tem';    % temporary name, as we won't be saving
ROI.viewType    = 'Gray';       % gray ROI

% default: have this new ROI be selected
select = true; 

% add roi to the view
vw = addROI(vw,ROI,select);

end