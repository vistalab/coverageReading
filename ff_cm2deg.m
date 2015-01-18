
function Vdeg = ff_cm2deg(visualDist, sz)
% INPUTS
% <visualDist> subject's distance from the stimuli, in units of cm
% <sz> size of whatever we're tring to covert to visual angle degrees, in units of cm
%     can be a matrix
% 
% OUTPUTS
% <Vdeg> a variable with the same dimensions as sz. 
%     corresponding visual angle degrees of whatever was in sz

% this is in radians
Vrad = 2*atan(sz/(2*visualDist)); 
% Vrad = 2*atan(sz/(visualDist));



% this is in degrees
Vdeg = rad2deg(Vrad); 

end