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

%% Colors corresponding to the 20 subjects in the FOV paper
% hand pick
list_colorsPerSub(1,:)      = [ 1   0.5   0];
list_colorsPerSub(2,:)      = [ 1   1   .5];
list_colorsPerSub(3,:)      = [ .8   .7   .5];
list_colorsPerSub(4,:)      = [.8   0     0];
list_colorsPerSub(5,:)      = [1    0.1    0.1];
list_colorsPerSub(6,:)      = [.6   1     0];
list_colorsPerSub(7,:)      = [0   0.5     .9];
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

%% Figures corresponding to the Wang ROIs
% There are 25 of them

% list_colorsWangRois = rand(25,3); 

list_colorsWangRois = zeros(25,3); 
list_colorsWangRois(1,:) = [89, 45 18];     % V1v
list_colorsWangRois(2,:) = [89, 45 18];     % V1d
list_colorsWangRois(3,:) = [160, 22, 158]; 	% V2v
list_colorsWangRois(4,:) = [160, 22, 158]; 	% V2d
list_colorsWangRois(5,:) = [22, 22, 160];   % V3v
list_colorsWangRois(6,:) = [22, 22, 160];   % V3d
list_colorsWangRois(7,:) = [33, 141, 198];  % hV4
list_colorsWangRois(8,:) = [17, 122, 71];   % VO1
list_colorsWangRois(9,:) = [139, 150, 21];  % VO2
list_colorsWangRois(10,:) = [224, 121, 11]; % PHC1`    
list_colorsWangRois(11,:) = [160, 9, 9];    % PHC2    
list_colorsWangRois(12,:) = [25, 16, 91];   % TO2    
list_colorsWangRois(13,:) = [153, 73, 16];  % TO1
list_colorsWangRois(14,:) = [186, 22, 183]; % LO2
list_colorsWangRois(15,:) = [103, 21, 142]; % LO1
list_colorsWangRois(16,:) = [2, 208, 255];  % V3B
list_colorsWangRois(17,:) = [21, 175, 36];  % V3A
list_colorsWangRois(18,:) = [239, 76, 76];  % IPS0
list_colorsWangRois(19,:) = [237, 160, 78]; % IPS1
list_colorsWangRois(20,:) = [252, 238, 108];% IPS2
list_colorsWangRois(21,:) = [96, 196, 126]; % IPS3
list_colorsWangRois(22,:) = [91, 171, 211]; % IPS4
list_colorsWangRois(23,:) = [174, 123, 196];% IPS5
list_colorsWangRois(24,:) = [255, 145, 231];% SPL1
list_colorsWangRois(25,:) = [249, 177, 109];% FEF

list_colorsWangRois = list_colorsWangRois ./ 255; 
save('list_colorsPerWangRois.mat', 'list_colorsWangRois');

fig_legendWang

%% Run 1, Run 2, Average of 2 runs
%     [0.3020    0.1647    0.4627]  % purple dark
%     [0.6980    0.3725         0]  % orange dark
%     [0.1294    0.4588    0.5059]  % teal dark

%     [ 0.4745    0.3412    0.6235] % purple
%     [1.0000    0.5373         0] % orange
%     [0.1333    0.6314    0.7294] % teal

%% Colors corresponding to the WH 100 subject data

list_colorsWHSubjects = [
        0.1784    0.6655    0.3600
    0.1830    0.6103    0.5893
    0.4721    0.8381    0.9186
    0.0806    0.3930    0.9151
    0.1669    0.8642    0.5028
    0.8631    0.6520    0.2218
    0.5508    0.6365    0.1207
    0.2883    0.8166    0.5883
    0.6508    0.9410    0.3920
    0.8848    0.7701    0.8061
    0.5126    0.3386    0.6114
    0.8890    0.1195    0.1576
    0.9412    0.8912    0.0094
    0.5543    0.1212    0.4792
    0.3988    0.2939    0.9905
    0.2899    0.2856    0.2279
    0.1317    0.8847    0.1974
    0.7174    0.8778    0.1490
    0.6175    0.8937    0.7358
    0.1004    0.7647    0.8838
    0.6284    0.1078    0.6166
    0.9557    0.6832    0.4061
    0.7052    0.9414    0.3596
    0.3878    0.7587    0.6001
    0.0691    0.0565    0.0785
    0.0181    0.9730    0.6680
    0.3893    0.1235    0.6903
    0.2147    0.5960    0.8449
    0.5381    0.6426    0.3887
    0.6932    0.2495    0.3306
    0.4501    0.0716    0.1852
    0.6292    0.6728    0.8093
    0.6426    0.1697    0.4487
    0.0870    0.0109    0.2740
    0.4574    0.7124    0.9744
    0.6273    0.0187    0.3283
    0.4246    0.3286    0.2209
    0.5152    0.2184    0.0210
    0.5717    0.6052    0.7605
    0.3044    0.2448    0.7262
    0.0805    0.7063    0.6980
    0.1884    0.8577    0.9717
    0.0333    0.7286    0.8701
    0.5916    0.3933    0.7098
    0.7419    0.2689    0.1775
    0.6996    0.7565    0.4937
    0.2381    0.8533    0.0804
    0.6818    0.6797    0.5411
    0.6427    0.9031    0.6462
    0.6652    0.5016    0.5197
    0.1755    0.9562    0.5600
    0.4562    0.0709    0.5467
    0.0842    0.1633    0.3962
    0.9500    0.7522    0.6142
    0.5412    0.5416    0.2238
    0.5101    0.4662    0.4825
    0.1752    0.1067    0.9521
    0.0534    0.4385    0.4661
    0.4616    0.5066    0.4005
    0.0760    0.8582    0.4158
    0.9185    0.5772    0.2926
    0.8524    0.6492    0.9177
    0.6396    0.6687    0.1140
    0.8371    0.9821    0.8105
    0.6527    0.0958    0.4739
    0.2191    0.7063    0.4104
    0.3817    0.9082    0.2901
    0.5063    0.9185    0.2634
    0.7868    0.4170    0.3520
    0.0048    0.9263    0.4366
    0.7914    0.3713    0.6406
    0.1307    0.4569    0.2306
    0.2149    0.3621    0.7055
    0.3575    0.1954    0.6638
    0.5479    0.0418    0.1302
    0.1365    0.0116    0.5663
    0.5198    0.4710    0.6200
    0.7189    0.6082    0.8819
    0.7908    0.8386    0.8137
    0.7204    0.2963    0.2382
    0.2176    0.6309    0.4845
    0.2198    0.9534    0.2249
    0.6828    0.0291    0.2347
    0.6760    0.2678    0.1556
    0.2494    0.5154    0.7655
    0.0654    0.4001    0.4358
    0.9444    0.3794    0.9533
    0.4320    0.2325    0.4410
    0.0360    0.6076    0.0513
    0.3311    0.8663    0.9960
    0.6364    0.7442    0.0697
    0.0472    0.2366    0.5378
    0.5040    0.6988    0.8486
    0.5772    0.9299    0.6861
    0.2163    0.3039    0.9127
    0.9583    0.1245    0.9762
    0.1840    0.2048    0.3145
    0.8791    0.6617    0.7925
    0.4829    0.7836    0.7201
    0.4359    0.6820    0.3877
    ];
