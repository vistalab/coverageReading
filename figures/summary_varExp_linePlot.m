


color1 =     [.8 0 .8];
color2 =     [.8 0 .2];
color3 =     [.2 0 .8];
    

descripts = {
    'Cross-Validated'
    'Words'
    'FalseFont'
    };

roiNames = {
    'WangV1v'
    'WangV2v'
    'WangV3v'
    'WanghV4'
    'lVOTRC'
    };

varexp1 = [
    .488
    .709
    .80224
    .823
    .477
    ];
varexp2 = [
    .51 
    .7
    .8
    .81
    .57
    ];
varexp3 = [
    .64
    .85
    .94
    .92
    .48
    ];

numRois = length(roiNames)

%%
close all; 
figure; hold on; 

plot(varexp1, 'color', color1, 'marker', 'o', 'linewidth',2, ...
    'markerfacecolor', color1,  'markeredgecolor', [0 0 0])
plot(varexp2, 'color', color2, 'marker', 'o', 'linewidth',2, ...
    'markerfacecolor', color2,  'markeredgecolor', [0 0 0])
plot(varexp3, 'color', color3, 'marker', 'o', 'linewidth',2, ...
    'markerfacecolor', color3,  'markeredgecolor', [0 0 0])

ylim([0 1])
xlim([0.5 numRois+.5])
grid on; 

set(gca, 'xtick', [1:numRois])
set(gca, 'xticklabel', roiNames)

ylabel('% voxels with varExp > 50%', 'fontweight', 'bold')
legend(descripts)





