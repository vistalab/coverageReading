function cellStr = ff_stringRemoveSweeps(strBase, numToAppend, strAfter)
%% a very specific function
% appends numbers to a string base
% returns a <numToAppend>x1 cell of strings
% EX: cellStr = ff_stringRemoveSweeps('Words_Remove_Sweep_',8,'-css.mat')
% cellStr = {
%     'Words_Remove_Sweep1-css.mat'
%     'Words_Remove_Sweep2-css.mat'
%     'Words_Remove_Sweep3-css.mat'
%     'Words_Remove_Sweep4-css.mat'
%     'Words_Remove_Sweep5-css.mat'
%     'Words_Remove_Sweep6-css.mat'
%     'Words_Remove_Sweep7-css.mat'
%     'Words_Remove_Sweep8-css.mat'
%     };
%
% If numToAppend = 0, will just return a string base o

cellStr = cell(numToAppend,1); 
for ii = 1:numToAppend    
    cellStr{ii} = [strBase num2str(ii) strAfter]; 
end




end