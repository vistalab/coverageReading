% make the contrasts specified in pmap_fromGLM for all subjects in
% bookKeeping

clear all; close all; clc; 
bookKeeping

for ii = 1:length(list_sessionLocPath)
   chdir(list_sessionLocPath{ii})
   
   pmap_fromGLM; 
   close all; 

end