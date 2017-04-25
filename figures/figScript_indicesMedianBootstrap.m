%% Get a confidence interval on the median value by bootstrapping
% Quick and dirty code. Some assumptions made.

clear all; close all; clc; 

%%

ipsiIndex = [

 0.2084    0.1187    0.1143    0.0954         0

    0.2953    0.0325    0.0600    0.3510    0.3415

    0.6507    0.1922    0.0887    0.4475    0.5970

    0.1502    0.1455    0.0416    0.0618    0.2105

    0.7957    0.1738    0.0669    0.1080    0.2690

    0.8770    0.4840    0.3339    0.2016    0.3309

    0.3499    0.0547    0.0342    0.0630    0.3830

    0.0685    0.0124    0.0780    0.2932    0.3933

    0.0966    0.0686    0.0083    0.1373    0.0592

    0.1509    0.0909    0.0543    0.1845    0.5980

    0.1402    0.1111    0.0765    0.1067    0.1073

    0.9452    0.2609    0.1212    0.3467    0.3007

    0.1680    0.3465    0.0798    0.2002    0.1876

    0.1980    0.1635    0.3124    0.5050    0.8204

    0.2834    0.3485    0.0461    0.0728    0.6667

    0.2070    0.1031    0.1289    0.2338    0.2761

    0.5009    0.0640    0.1207    0.1478    0.7136

    0.0767    0.0024    0.0095    0.0841    0.0720

    0.6256    0.4267    0.0413    0.0508    0.3968
    0.4030    0.1411    0.1614    0.2150    0.3089    ]

eccIndex = [

  0.7654    0.4411    0.4057    0.4339    0.1491

    0.8020    0.8652    0.7811    0.0054         0

    0.7165    0.5263    0.6612    0.0075    0.0147

    0.7510    0.5184    0.8185    0.4391         0

    0.8805    0.6519    0.5712    0.1788    0.0333

    0.8874    0.3917    0.4578    0.5561    0.2569

    0.7759    0.7869    0.5758    0.3893         0

    0.9917    0.7389    0.6191    0.0015    0.2773

    0.7827    0.6319    0.7145    0.2663    0.4048

    0.6950    0.7528    0.7743    0.3956         0

    1.0511    0.9923    0.6429    0.3191    0.1930

    0.9334    0.6092    0.6787    0.4519    0.0187

    0.7220    0.5297    0.7144    0.0909         0

    0.6216    0.4672    0.4898    0.2150    0.0088

    0.6696    0.5255    0.7819    0.2823         0

    0.8350    0.6573    0.6889    0.5264    0.0366

    0.7018    0.7444    0.6818    0.3963         0

    1.0599    1.2192    0.8204    0.1761         0

    0.8907    0.7133    0.6412    0.7441    0.3225

    0.5855    0.4272    0.5506    0.4414         0 ]

%% do things
fovIndex = 1-eccIndex; 
conIndex = 1-ipsiIndex; 

% how many times to bootstrap
numBoots = 1000; 

% percentiles we are interested in
percents = [2.5 97.5];

% number of rois in this calculation
numRois = size(fovIndex,2);

% intialize
mediansBootstrapFov = zeros(numBoots,numRois);  
mediansBootstrapCon = zeros(numBoots,numRois);  


for jj = 1:5

    roiFovIndices = fovIndex(:,jj); 
    roiConIndices = conIndex(:,jj);
    
    temFov = bootstrp(numBoots,@median,roiFovIndices);
    temCon = bootstrp(numBoots,@median,roiConIndices);
    
    mediansBootstrapFov(:,jj) = temFov; 
    mediansBootstrapCon(:,jj) = temCon; 

end

%% confidence intervals
confidenceFov = prctile(mediansBootstrapFov, percents)

confidenceContra = prctile(mediansBootstrapCon, percents)
