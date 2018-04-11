function lthetas_constrain =  ff_polarAngleBetween0AndPi(lthetas)
% lthetas_constrain =  ff_polarAngleBetween0AndPi(lthetas)
% 
% lthetas is a vector of rotations (between 0 and 2pi)
% This function characterizes the rotation between 0 and pi.
% Useful for when we don't need to know the direction of the rotation but
% rather the magnitide of it. 
%
% Values greater than pi are subtracted from 2pi
%
%% checks

if ~isempty(lthetas)
    if max(lthetas) > 2*pi || min(lthetas) < 0
        error('Input vector needs to be between 0 and 2pi')
    end

    lthetas_constrain = lthetas;

    indsOver = lthetas > pi; 
    valuesOver = lthetas(indsOver);
    values = 2*pi - valuesOver; 
    lthetas_constrain(indsOver) = values; 
else
    lthetas_constrain = []; 
end


end