

%% Left VOTRC. 
% Total number of voxels in the ROI:
lvotrc_numVoxels = [
352
1062
 967
 348
1261
1570
 380
 554
  14
 427
 318
 623
 203
 243
 765
 478
 301
  57
 578
 434
 ]; 

% Left VOTRC> Voxels that exceed threshold:
lvotrc_numVoxelsExceedThresh = [
80
576
379
58
788
656
260
51
11
189
158
586
44
222
224
247
242
4
313
268
];

lvotrc_percentExceedThresh = lvotrc_numVoxelsExceedThresh./ lvotrc_numVoxels;

ans = [

    0.2273
    0.5424
    0.3919
    0.1667
    0.6249
    0.4178
    0.6842
    0.0921
    0.7857
    0.4426
    0.4969
    0.9406
    0.2167
    0.9136
    0.2928
    0.5167
    0.8040
    0.0702
    0.5415
    0.6175
    ];

%% Right VOTRC
% number of voxels 
% Total number of voxels in ROI
rvotrc_numVoxels = [
  112
 260
1959
  31
 208
  87
 115
 304
 121
  61
 126
  20
 237
  40
 180
  62
  16
 111
  67
  22    
];

% Number of voxels that exceed threshold
rvotrc_numVoxelsExceedThresh = [
48
  19
1033
  20
 147
  13
   1
 188
  12
  61
  26
   8
 187
  14
  95
   3
  16
  43
  43
  13        
];

% Percentrage of voxels that exceed threshold
rvotrc_exceedThresh = rvotrc_numVoxelsExceedThresh ./ rvotrc_numVoxels;

ans = [
rvotrc_exceedThresh = [
    0.4286
    0.0731
    0.5273
    0.6452
    0.7067
    0.1494
    0.0087
    0.6184
    0.0992
    1.0000
    0.2063
    0.4000
    0.7890
    0.3500
    0.5278
    0.0484
    1.0000
    0.3874
    0.6418
    0.5909    
];