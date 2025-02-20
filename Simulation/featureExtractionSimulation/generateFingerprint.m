
%% Clear previously allocated memory
clear;
clc;
close all;

%% Path to image dataset
dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\norm";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\rot";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\trans";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\PNRroomSimpsons";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\PNRroomSimpsonsRotated";

% dsetPath = "C:\Users\Andrew\Desktop\Thesis\ThesisData\VerticalLines";
% Store the dataset into a structure that contains information about it
dset = getDset(dsetPath);

% Cool now that we've got the dataset, lets extract the features from t he
% images contained in the dataset

% Choose and store the image from the dataset based on the index
index = 100;
img = f_displayImageFromDset(dset, index);
% img = imrotate(img, 90);
% Ensure the image is grayscale
if size(img, 3) > 1
    img = rgb2gray(img);
end


% img = imread('cameraman.tif'); % Load a sample grayscale image
% pixelValues = extractHorizontalLinePixels(img);

num_bins = 100;   % Number of bins (5-degree increments)
num_samples = 5000; % Number of random lines


%% After we choose the image, lets choose what features to extract out of
%  the image

% % Parameters
% num_bins = 72;   % Number of bins (5-degree increments)
% num_samples = 5000; % Number of random lines
% line_length = 100;
% Call the extraction function
% This one is for standard deviation
% [angle_hist, avg_std_dev] = f_extractStdDeviation(img, num_bins, num_samples);
%  f_sumOfSquaresFeatureAndHistogram(img, num_bins, num_samples, lineLength, hist_type)
% f_sumOfSquaresFeatureAndHistogram(img, num_bins, num_samples, line_length, '1d');

%% Parameters for the 2D histogram
numLines = 10000;       % Number of random lines/curves
lineLength = 100;       % Length of each line in pixels --> try different line lengths
numBinsFeature = 100;   % Number of bins for the feature (sum of derivatives)
numBinsAngle = 100;     % Number of bins for the angle (0-360 degrees, 18 bins for 20-degree intervals)

%% Generate and plot the 2D histogram
% [angles, sumDerivatives, angleEdges, featureEdges, counts] = f_generateHist(img, numLines, lineLength, numBinsFeature, numBinsAngle);
[pixelValue1, pixelValue2, correlations] = f_correlationHistogram(img, num_samples, num_bins);
% [angles, sumSecondDerivatives, angleEdges, featureEdges, counts] = f_generateHistogramSecondDerivative(img, numLines, lineLength, numBinsFeature, numBinsAngle);
% f_jointPixelDistributionHeatmap(img, num_bins, num_samples);


%% Sanity check for verifying the distribution of angles
%% Define bins for the histogram
% numBins = 100; % Number of bins
% binEdges = linspace(0, max(angles), numBins + 1); % Bin edges
% binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2; % Bin centers
% 
% % Compute the histogram
% angleCounts = histcounts(angles, binEdges);
% 
% % Plot the histogram
% figure;
% bar(binCenters, angleCounts, 'FaceColor', [0.2 0.6 0.8]);
% xlabel('Angle (degrees)');
% ylabel('Frequency');
% title('Distribution of Angles');
% grid on;
% set(gca, 'XTick', 0:30:360); % Set x-axis ticks at every 30 degrees