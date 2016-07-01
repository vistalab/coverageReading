function rfcovSampleMean = ff_rfcovArrayMean(rfcov_list, vfc)
% rfcovSampleMean = ff_rfcovArrayMean(rfcovSample)
% rfcovSample is a numSample x 1 array where each element is a vfc.nSamples
% x vfc.nSamples matrix. We average over all of these

numSamples = length(rfcov_list);
rfcov3d = zeros(vfc.nSamples, vfc.nSamples, numSamples);

for ii = 1:numSamples
    
    % concatenate into a 3 dimensional matrix
    rfcov3d(:,:,ii) = rfcov_list{ii};
    
end

rfcovSampleMean  = mean(rfcov3d, 3);

end