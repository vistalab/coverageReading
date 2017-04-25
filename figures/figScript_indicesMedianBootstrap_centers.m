%% Get a confidence interval on the median value by bootstrapping
% Quick and dirty code. Some assumptions made.

clear all; close all; clc; 

%%

conIndex = [
	0.9380    0.9949    0.9881    0.9885    1.0000

	0.9511    0.9987    0.9356    0.7764    0.9640

	0.9850    0.9568    1.0000    0.9712    0.9673

	0.9788    0.9956    1.0000    1.0000    1.0000

	0.9866    1.0000    1.0000    1.0000    1.0000

	0.7847    0.8966    0.9803    0.9766    0.7985

	0.9912    0.9988    1.0000    0.9829    0.9961

	1.0000    1.0000    1.0000    1.0000    1.0000

	0.9964    1.0000    1.0000    1.0000    1.0000

	0.9950    1.0000    1.0000    0.8903    0.5349

	0.9609    0.9931    1.0000    0.9524    1.0000

	0.8289    0.9717    1.0000    1.0000    1.0000

    0.9970    0.9982    0.9960    1.0000    1.0000

    0.8895    0.9919    1.0000    0.9855    0.6038

	0.9897    0.9976    1.0000    1.0000    0.9864

	0.9964    1.0000    1.0000    0.8220    0.9489

	0.9731    0.8876    0.9754    0.9828    0.9874

	0.9980    1.0000    1.0000    1.0000    1.0000

	0.9729    0.9959    1.0000    1.0000    0.9805

    0.9334    1.0000    0.9985    0.9405    0.9925
 ]


fovIndex = [
	0.7805    0.9010    0.9359    1.0000    1.0000

	0.8682    0.8863    0.8186    1.0000    1.0000

	0.9183    0.8285    0.7135    1.0000    1.0000

	0.8457    0.8172    0.8623    0.9770    1.0000

	0.8969    0.9070    0.9324    1.0000    1.0000

	0.7727    0.7936    0.8404    0.9603    1.0000

	0.8049    0.8490    0.8356    1.0000    1.0000

	0.5426    0.8467    0.9290    1.0000    0.9592

	0.8597    0.9141    0.8094    0.9982    0.9000

	0.7749    0.8191    0.8897    0.9971    1.0000

	0.7178    0.6595    0.8256    1.0000    1.0000

	0.7956    0.8507    0.9105    0.9776    1.0000

	0.8528    0.9452    0.7277    1.0000    1.0000

	0.7903    0.9149    0.9538    1.0000    1.0000

	0.8907    0.8714    0.8589    1.0000    1.0000

	0.7131    0.8754    0.7958    0.9764    1.0000

	0.8613    0.9008    0.7666    0.9691    1.0000

	0.6661    0.7010    0.7542    1.0000    1.0000

	0.8150    0.9252    0.8561    0.6822    1.0000

	0.8955    0.8529    0.7692    1.0000    1.0000
 ]

%% do things
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
