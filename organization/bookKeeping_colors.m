%% Want colors to be consistent across figures.
% BE CAREFUL ABOUT OVERWRITING
% We can imagine we'd want the same colors across figures for rois,
% subjects, stimulus types ...

clear all; close all; clc; 
bookKeeping;
chdir('/biac4/wandell/data/reading_prf/coverageReading/organization')

%% initialize
numSubs = length(list_sub);
list_colorsPerSub = zeros(numSubs, 3);

%% define the colors!

% hand pick
list_colorsPerSub(1,:)      = [ 1   0.5   0];
list_colorsPerSub(2,:)      = [ 1   1   .5];
list_colorsPerSub(3,:)      = [ .8   .7   .5];
list_colorsPerSub(4,:)      = [.8   0     0];
list_colorsPerSub(5,:)      = [1    0.1    0.1];
list_colorsPerSub(6,:)      = [.6   1     0];
list_colorsPerSub(7,:)      = [.6   0.8     0];
list_colorsPerSub(8,:)      = [.6   0     0.9];
list_colorsPerSub(9,:)      = [.7   0     .5];
list_colorsPerSub(10,:)     = [.6   0     1];
list_colorsPerSub(11,:)     = [0   0.8   0];
list_colorsPerSub(12,:)     = [0   .5   .7];
list_colorsPerSub(13,:)     = [.5  .5  .5];
list_colorsPerSub(14,:)     = [0.7  0.7    1];
list_colorsPerSub(15,:)     = [1  .7    0];
list_colorsPerSub(16,:)     = [0    0.7   0.9];
list_colorsPerSub(17,:)     = [0    0.2   1];
list_colorsPerSub(18,:)     = [.7    0.9   0.8];
list_colorsPerSub(19,:)     = [.5    0   .4];
list_colorsPerSub(20,:)     = [ .8  0    .8];

save('list_colorsPerSub.mat', 'list_colorsPerSub')

fig_legendSubject; 

%%
%     [0.3020    0.1647    0.4627]  % purple dark
%     [0.6980    0.3725         0]  % orange dark
%     [0.1294    0.4588    0.5059]  % teal dark

%     [ 0.4745    0.3412    0.6235] % purple
%     [1.0000    0.5373         0] % orange
%     [0.1333    0.6314    0.7294] % teal