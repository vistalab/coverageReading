function [descript] = ff_dec2str(number)
%% converts a number with a decimal point into a format that will not crash code later
% converts the decimal into 'p', returns a string
% ex: 3.2 becomes 3p2
% 
% 
% INPUTS: 
% number: the number. If this is a whole number, the code will simply
% return the whole number
% RETURNS: 
% descript

if ischar(number)
    descript = number; 
    return
end

base = floor(number); 

descript = [num2str(base)]; 

% the modulus
m = mod(number, base);

% if a whole number, don't need to append p
if m == 0
    return
else
    numDigits = length(num2str(m)) - 2; 
    mWhole = (10^numDigits)*m; 
    descript = [descript 'p' num2str(mWhole)];
end

end