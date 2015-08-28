function c2v_fixGuiClip(VOLUME, v)
% the problem was that the clipMode was set to 0 as opposed to a range, so
% everything was assigned one color. Change the clip modes here

% changing clip mode for eccentricity (parameter map field)
tem.mapMode             = viewGet(VOLUME{end},'mapMode');
tem.mapModeNew          = tem.mapMode; 
tem.mapModeNew.clipMode = [0 v.fieldSize];
VOLUME{end} = viewSet(VOLUME{end}, 'mapMode', tem.mapModeNew);  
VOLUME{end} = refreshView(VOLUME{end});
VOLUME{end} = refreshScreen(VOLUME{end});

% change the clip mode for the amplitude map
tem.ampMode             = viewGet(VOLUME{end},'ampMode');
tem.ampModeNew          = tem.ampMode; 
tem.ampModeNew.clipMode = [0 2*v.fieldSize] ;
VOLUME{end} = viewSet(VOLUME{end},'ampMode',tem.ampModeNew);
VOLUME{end} = refreshView(VOLUME{end});
VOLUME{end} = refreshScreen(VOLUME{end});


end