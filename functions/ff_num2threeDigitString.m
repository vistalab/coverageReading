function str = ff_num2threeDigitString(number)
% converts a non-negative integer < 1000 into a three digit string
% for files naming convention.
% Examples
% ff_num2threeDigitString(1) becomes 001
% ff_num2threeDigitString(12) becomes 012
% ff_num2threeDigitString(456) becomes 456
% ff_num2threeDigitString(1000) returns an error

if number > 999 || number < 0
    error('Number must be in between 0 and 999')
end

if number < 10
    str = ['00' num2str(number)];
elseif number < 100 
    str = ['0' num2str(number)];
elseif number < 1000
    str = num2str(number);
end

end