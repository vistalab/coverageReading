function rootPath=crRootPath()
%
%        rootPath =mrvRootPath;
%
% Determine path to root of the coverageReading directory
%
% This function MUST reside in the directory at the base of the
% coverageReading directory structure
%
% Wandell

rootPath=which('crRootPath');

[rootPath,fName,ext]=fileparts(rootPath);

return
