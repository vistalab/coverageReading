%% Plot in 3d: CTOPP, WORD ID, TOWRE

clear all; close all; figure; 

xAxisLabel = 'WORD ID';
yAxisLabel = 'TOWRE';
zAxisLabel = 'CTOPP'; 

xDataConcat = [ 
      110
   103
    80
    89
   110
    95
   115
   105
    70
   115
   113
    95
   111
    99
    99
    89
    91
   100
   100
   114
   102
   106
    84
   120
   112
    97
    94
   113
   103
   122
   103
    97
   117
    98
   117
    88
   112
   115
   123
   101
   106
    88
   111
    87
   136
   116
   134
   105
   123
   133
    86
    93
   100
   131
   115
   119
   118
    92
   113
    86
   117
   113
    90
   103
    96
   111
   100
    99
    95
    85
    97
   100
   105
   111
    84
   120
    87
    88
   101
   104
   122
   113
   101
   121
   108
   101
   103
   127
    99
   104
    88
    88
   121
   130
   115
   133
   120
    88
    90
   110
   124
   122
   115
    98
   114
    85
   120
    97
    94
   113
   105
   105
    95
    80
    96
   110
   105
   101
    84
   134
    92
    98
   103
   113
   114
    99
   115
   100
   102
   120
    98
   100
    90
    89
   127
   130
   112
   121
    97
    91
   100
   130
   106
   117
    93
   116
    84
   101
   108
    92
   107
   100
    79
    98
   107
   105
   109
   116
   101
   104
   120
   115
   127
   116
   103
   118
    96
   103
    88
   120
   117
    90
   106
   124
   111]; 

yDataConcat =   [ 126
   109
    71
    88
   104
    92
   109
    96
    72
   111
   117
    95
    95
    89
   102
    89
    86
    93
    90
   111
    96
   116
    74
   123
   118
    77
    81
   128
   111
   110
    92
    87
    96
    97
    90
    84
   104
   123
   115
   101
   111
    78
   105
    79
   115
   125
   140
    95
   116
   131
    86
    88
    92
   140
   137
   125
   118
    90
    97
    74
   102
    93
    86
   114
    98
    97
    94
   105
    87
    79
    81
   105
   115
   111
    75
   117
    70
    81
   123
   108
   123
    93
    90
   109
    92
    87
   109
   129
   102
   104
    77
    87
   125
   134
   103
   128
   131
    85
    90
   110
   146
   131
   113
    93
    98
    87
    98
    87
   103
   101
    90
   111
    90
    78
    88
    96
   110
   113
    72
   116
    86
   118
   104
   126
   101
    90
   100
    93
    87
   120
   101
   102
    75
    87
   119
   128
   103
   116
    89
    89
   113
   140
   135
   126
    95
   114
    78
    89
   121
   101
    95
   111
    80
    88
    99
   107
   103
   120
   128
    96
   118
    98
   104
    98
    86
   123
   107
   101
    83
   131
   111
    87
   110
   143
   133    
   ];


zDataConcat = [
            91
   103
    85
    73
   118
   100
   112
   118
    76
    85
   109
    91
   100
   103
    88
   103
    94
    91
    88
   118
    88
   103
    85
   118
   112
    91
    94
    94
    97
   118
   106
    88
   112
    97
   103
    85
    94
   100
   112
    91
   109
    91
   103
    91
   106
   121
   109
    82
   109
   133
    91
    94
    82
   121
    97
   100
   118
    91
   109
    82
   112
   106
   106
    88
    91
   100
   103
    88
   109
   109
    76
   100
   109
   103
    79
   112
    85
    91
   103
    88
   121
   109
   106
   124
   112
   109
    79
   112
    85
   100
    97
    91
   115
   118
   103
   121
   124
    91
   106
   100
   121
   100
   100
   103
   112
    82
   118
   112
    91
   106
    97
    97
   109
   106
   100
    76
   118
   115
    79
   118
    91
   109
    85
   124
   118
   112
   118
   112
   121
   115
   106
    97
   103
   103
   118
   121
   100
   124
   109
   112
   106
   118
   109
   115
   109
   115
    82
   115
    82
    94
   103
    97
    94
    97
   103
   118
   115
   118
   118
    91
   124
   115
   115
   109
   130
   118
   115
   106
   103
   121
   124
   112
   112
   124
   112
    ];

ageDataConcat = [   11.4900
   10.1300
    9.0200
   11.3900
    9.9700
    7.4600
   11.6900
   10.3200
   10.8600
   11.7300
   10.4100
    7.8700
   11.1400
    7.1800
    9.5800
   10.1900
    8.6200
   10.5800
   10.2700
   10.7300
   11.9900
   10.1200
    9.8400
   11.7800
    9.1200
    7.2000
    8.2600
   11.7000
    8.6000
    7.7300
   11.5800
   10.8400
    8.2500
    7.4700
    7.0100
    9.7800
   10.7000
   10.9300
   11.0000
    9.7200
    7.5100
    9.0500
    7.5600
    9.4700
   11.8300
    9.4600
    9.9300
   10.7700
    9.1500
    7.0100
   10.8500
    8.6100
   10.7700
    7.6000
   10.2100
   12.4700
   11.1800
   12.4100
   10.9800
    8.4200
   12.6800
   11.3300
   11.8600
   12.7200
    8.7800
   12.1200
    8.0900
   10.4900
   11.1000
    9.6400
   11.5900
   11.2800
   11.6900
   11.2400
   10.7900
   12.7700
    8.1000
    9.2100
   12.7000
    9.7000
    8.7900
   12.5600
   11.7400
    9.1800
    8.4800
    8.0100
   11.5700
   12.0200
   10.7000
    8.5200
    9.9500
   10.4300
   10.4300
   10.9900
   11.7100
   10.1100
    7.9900
   11.8400
    9.5500
   11.7400
    8.5900
   11.2200
   13.4700
   13.4100
   11.9100
    9.4700
   13.6700
   12.8100
    9.8100
   13.1200
    9.1100
   11.5100
   12.1300
   10.6500
   12.6400
   12.1900
   12.6900
   12.2500
   11.8500
   13.7800
   10.1300
   13.7200
   10.7000
    9.7900
   13.5700
   12.7700
   10.1800
    9.4100
    9.0300
   13.0400
   11.6300
    9.5400
   10.9800
   11.4500
   11.4600
   11.9600
   12.7100
    8.9000
   12.8800
   10.6700
   12.7900
    9.6000
   12.2200
   14.3800
   14.6200
   12.8300
   10.2900
   13.7800
   14.8000
   10.8600
   10.1500
   12.5600
   11.7200
   13.8200
   13.1400
   13.4900
   13.3200
   14.9900
   14.7700
   11.6600
   10.7100
   14.6500
   11.2300
   10.3400
    9.9500
   14.1000
   12.6900
   10.4700
   12.3800
   13.0700
    9.9800
   13.7000
   13.7800
   10.8100
   13.4400];

numPoints = length(xDataConcat)

%% to go from age to color
c = colormap('parula');

ageMin = min(ageDataConcat); % 9.95. want this to be mapped to 0 
ageMax = max(ageDataConcat); % 14.99. want this to be mapped to 1

%% try to add the projections
close all; figure; hold on; 
% 
numPoints = length(xDataConcat);
xProject = 60; 
yProject = 150; 
zProject = 60; 

color1 = [.8 .8 .8]; %[.9 .6 .6];
color2 = [.8 .8 .8]; %[.6 1 .6];
color3 = [.8 .8 .8]; %[.6 .6 1];

axis([60 140 50 150 60 140])

plot3(xDataConcat, ones(1,numPoints).*yProject, zDataConcat, 'o', ...
    'markerfacecolor', color1, 'markeredgecolor', 'none')

plot3(xDataConcat, yDataConcat, ones(1,numPoints).*zProject, 'o', ...
    'markerfacecolor', color2, 'markeredgecolor', 'none')

plot3(ones(1,numPoints).*xProject, yDataConcat, zDataConcat, 'o', ...
    'markerfacecolor', color3, 'markeredgecolor', 'none')

%% add the 3d points
hold on; 
[x,y,z] = sphere; 

for ii = 1:length(xDataConcat)
    
    temX = xDataConcat(ii); 
    temY = yDataConcat(ii);
    temZ = zDataConcat(ii);
    age  = ageDataConcat(ii); 
    
    % which of the 64 numbers does this subject's age correspond to?
    % age color is a number between 0 and 1
    ageColor = (age -ageMin) / (ageMax - ageMin);
    ageColorInd = max(round(ageColor*64),1); % max(round(ageColor*64),1); 
    
    % 3d POINTS
    surf(x + temX, y+temY, z+temZ, 'edgecolor', 'none', ...
        'facecolor', c(ageColorInd,:))

    % FLAT POINTS
%     plot3(temX, temY, temZ, 'o', 'markerfacecolor', c(ageColorInd, :), ...
%         'markeredgecolor', [1 1 1], 'markersize', 12)
    
end

grid on; 
camlight;
lightangle(58.5,16.0)
% lightangle(-45,30)
view([58.5 16.0])

xlabel(xAxisLabel)
ylabel(yAxisLabel)
zlabel(zAxisLabel)

whitebg([1 1 1])
set(gcf, 'Color', [1 1 1])

