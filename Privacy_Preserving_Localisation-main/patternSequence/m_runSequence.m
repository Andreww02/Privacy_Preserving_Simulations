clear;
clc;
close all;

% Load dataset
dsetName = "C:\Users\Andrew\Desktop\Thesis\ThesisData\PNRroomSimpsons";
dset = getDset(dsetName);

% Parameters
nCircles = 3000;                % Number of circles
radii = [20, 50];               % Radius range [minRadius, maxRadius]
nSamples = 1000;                % Points per circle
isNormalise = false;            % Disable normalization


% Select image for testing
imgIndex = 1;                   % Choose any index from the dataset
img = readimage(dset.imageSet, imgIndex); % Read the image from the datastore
imgSize = size(img);


% Generate circle sampling points
[xToSample, yToSample] = generateCircleSamplesPts(imgSize, nCircles, radii, nSamples);


% Extract max and min features
[features, metrics] = maxMinFeaturesAlongCurves(img, xToSample, yToSample, isNormalise);

% Extract max and min values
maxFeatures = features(:, 1);  % Assuming column 1 is max values
minFeatures = features(:, 2);  % Assuming column 2 is min values