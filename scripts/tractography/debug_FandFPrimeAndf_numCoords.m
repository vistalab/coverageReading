%% Things to check
% f runs through fNumVoxels unique voxels
% The intersection of F and f should be this number
% The intesrection of F' and f will be lower

%% modify here

% full path of f:
fPath = '/sni-storage/wandell/biac2/wandell2/data/anatomy/camacho/ROIsFiberGroups/LGN-V1.pdb';

% full path of F and FPrime
FPath = '/sni-storage/wandell/biac2/wandell2/data/anatomy/camacho/ROIsConnectomes/LGN-V1_pathNeighborhood.pdb';
FPrimePath = '/sni-storage/wandell/biac2/wandell2/data/anatomy/camacho/ROIsConnectomes/LGN-V1_pathNeighborhood-PRIME.pdb';

% full path fe struct fitted to F (fe1) and FPrime (fe2)
fe1Path = '/sni-storage/wandell/data/reading_prf/cc/diffusion/LiFEStructs/LGN-V1_pathNeighborhood_LiFEStruct.mat';
fe2Path = '/sni-storage/wandell/data/reading_prf/cc/diffusion/LiFEStructs/LGN-V1_pathNeighborhood-PRIME_LiFEStruct.mat';

%% load things
% the fe structs. rename accordingly
load(fe1Path); 
fe1 = fe; clear fe
load(fe2Path); 
fe2 = fe; clear fe

% the xform
xform = feGet(fe1,'xform'); 

% f things
f = fgRead(fPath); % this is in acpc space
fImg = dtiXformFiberCoords(f, xform.acpc2img); % this is in img space

% F and Fprime. these are in acpc space ...
F = fgRead(FPath); 
FPrime = fgRead(FPrimePath);
% ... so xform to image space
FImg = dtiXformFiberCoords(F, xform.acpc2img); 
FPrimeImg = dtiXformFiberCoords(FPrime, xform.acpc2img); 

%% sanity checks
% everything passes now

FPrimeUniqueCoords = fgGet(FPrimeImg, 'uniqueimagecoords');

% FImg and fe1.fg should be identical
% FPrimeImg and fe2.fg should be identical
FUniqueCoords = fgGet(FImg, 'uniqueimagecoords');
numUniqueCoordsF = length(FUniqueCoords);
% ^ this number is 103043x3
% which is also the length of fe1.roi.coords
roi1Coords = feGet(fe1, 'roi coords');

checking = ismember(FUniqueCoords, roi1Coords, 'rows'); 
sum(checking) % should be 103043
% OH NO. even though they are the same length, they are not equal

checking2 = ismember(FUniqueCoords, fgGet(fe1.fg, 'uniqueimagecoords'), 'rows');
sum(checking2)

fgImgUniqueCoords = fgGet(feGet(fe1, 'fgimg'),'uniqueimagecoords');
checking3 = ismember(roi1Coords,fgImgUniqueCoords, 'rows');
sum(checking3)

%% Check to see whether the intersection of F and f are the length of f
% It is!!! :-)
% fImgCoordsUnique
FIntersectionf = ismember(FUniqueCoords,fImgCoordsUnique, 'rows');
sum(FIntersectionf)

% What about the intersection of F' and f?
FPrimeIntersectionf = ismember(FPrimeUniqueCoords, fImgCoordsUnique, 'rows'); 
sum(FPrimeIntersectionf)

%% FPrime does not intersect  the same coordinates that f does 
% To properly do the rmse comparison, ....

% Get the indices of coordinates where FPrime intesects f. 
% Then find the indices where these coordinates are in F (all of them should be)