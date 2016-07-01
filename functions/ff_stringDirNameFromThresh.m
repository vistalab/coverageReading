function dirNameString = ff_stringDirNameFromThresh(h)
%% Folder directory names based on how we threshold the prf fits
% We can threshold prf fits many different ways
% We make folder names with these different ways of thresholding
%
% h should have the following fields. An example:
% h.threshecc = [0.1 15]; 
% h.threshco = 0.1;
% h.threshsigma = [0 15]; 
% h.minvoxelcount = 1; 

% example output:
% varExo0p1-ecc0p1_15-sigma0_15-minVox1

%% varExp
co = h.threshco; 
costr = ff_dec2str(co);

%% ecc
ecc1 = h.threshecc(1); 
ecc2 = h.threshecc(2); 
ecc1str = ff_dec2str(ecc1); 
ecc2str = ff_dec2str(ecc2); 

%% sigma
sig1 = h.threshsigma(1); 
sig1str = ff_dec2str(sig1); 

sig2 = h.threshsigma(2); 
sig2str = ff_dec2str(sig2); 

%% put it all together
dirNameString = ['varExp' costr '-ecc' ecc1str '_' ecc2str '-sigma' sig1str '_' sig2str]; 

end