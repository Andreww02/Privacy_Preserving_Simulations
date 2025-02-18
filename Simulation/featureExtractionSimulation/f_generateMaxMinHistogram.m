function [maxVals, minVals, binEdgesMax, binEdgesMin, counts] = ...
    f_generateMaxMinHistogram(ax, img, nCircles, radii, nSample, isNormalise, numBinsMax, numBinsMin)
% f_generateMaxMinHistogram
%   Computes and plots a 2D histogram of the maximum and minimum pixel
%   intensities obtained along random circular paths in the image.
%
% Inputs:
%   ax          - Axes handle to plot the histogram.
%   img         - Input grayscale image.
%   nCircles    - Number of random circles to sample.
%   radii       - 2-element vector specifying the [minRadius, maxRadius].
%   nSample     - Number of sample points per circle.
%   isNormalise - Boolean flag indicating whether to normalize features.
%   numBinsMax  - (Unused) Number of bins for the maximum values.
%   numBinsMin  - (Unused) Number of bins for the minimum values.
%
% Outputs:
%   maxVals, minVals   - Vectors of maximum and minimum intensities along each circle.
%   binEdgesMax        - Bin edges for the maximum values.
%   binEdgesMin        - Bin edges for the minimum values.
%   counts             - 2D histogram counts.

    % Compute the features using your provided function.
    [features, ~] = f_maxMinFeaturesAlongUniqueRandCirc(img, nCircles, radii, nSample, isNormalise);
    % features is an [nCircles x 2] matrix: column 1 = max, column 2 = min
    maxVals = features(:, 1);
    minVals = features(:, 2);
    
    % Create fixed bin edges for pixel intensities 0-255.
    % These bin edges correspond to 256 bins covering 0 to 255.
    binEdgesMax = 0:256;   % 257 edges yield 256 bins
    binEdgesMin = 0:256;   % 257 edges yield 256 bins
    
    % Compute the 2D histogram using the fixed bin edges.
    counts = histcounts2(maxVals, minVals, binEdgesMax, binEdgesMin);
    
    % Apply a Gaussian filter for smoothing the histogram visualization.
    sigma = 20;                          % Standard deviation for the Gaussian kernel
    kernel = fspecial('gaussian', [5 5], sigma);
    
    gammaVal = 0.2;  % Example gamma value.
    gammaScaledCounts = counts .^ gammaVal; 
    countsFiltered = imfilter(gammaScaledCounts, kernel, 'same');
    % Plot the filtered histogram in the provided axes.
    axes(ax);              % Set current axes to ax.
    hold(ax, 'on');        % Ensure plotting remains on the same axes.
    imagesc(binEdgesMax(1:end-1), binEdgesMin(1:end-1), countsFiltered');
    set(ax, 'YDir', 'normal'); % Set y-axis to normal direction
    % colorbar(ax);

    % xlabel(ax, 'Max Intensity');
    % ylabel(ax, 'Min Intensity');
    % title(ax, 'Max-Min Histogram (Smoothed)');
    xlim(ax, [0 255]);
    ylim(ax, [0 255]);
    
    hold(ax, 'off');
end
