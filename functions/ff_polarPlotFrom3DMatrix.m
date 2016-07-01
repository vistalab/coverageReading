function ff_polarPlotFrom3DMatrix(rfcov, vfc, varargin)
% ff_polarPlotFrom3DMatrix(rfcov, vfc, varargin)
% ff_polarPlotFrom3DMatrix(rfcov, vfc, 'rmroi', rmroi, 'data', data)
% When we just have a matrix, lots of little steps to make a presentable
% coverage map (axis and black circle and grid lines etc). 
% This function tries to take care of that. 
%
% In this case we don't really specify the color map
% Makes a nice receptive field -
% Black outer ring
% Grid lines
%
% INPUTS
% rfcov is a numSamples x numSamples x 3
% vfc is visual field coverage struct

figure; hold on; 

%% optional input parameter: rmroi struct
pa = inputParser; 
pa.addOptional('rmroi', []);
pa.addOptional('data',[]);
pa.parse(varargin{:});
rmroi = pa.Results.rmroi;
if iscell(rmroi), rmroi = {1}; end; 

%%
% specify for the polar angle plot
inc = linspace(-vfc.fieldRange,vfc.fieldRange, vfc.nSamples);

% make the black outer circle thing
c = makecircle(vfc.nSamples);  
c = ones(vfc.nSamples); 

% overlap the black circle thing with each channel
% (Because note that rfcov is 3D)
rfcov_black_3c = zeros(size(rfcov)); 
for ii = 1:3
    rfcov_black_3c(:,:,ii) = rfcov(:,:,ii).*c; 
end

% overlap the contour with the prob map
% RFmean_black_contour = rfcov_black.*contourMatrix; 
% imagesc(inc,inc', rfcov_black_contour); 
imagesc(inc, inc', rfcov_black_3c); 

% add polar grid on top
p.ringTicks = (1:3)/3*vfc.fieldRange;
% p.color             = vfc.color; 
% p.fillColor         = vfc.fillColor; 
p.backgroundColor   = vfc.backgroundColor; % the only color related field that seems to make any difference
polarPlot([], p);

end