clear;
clc;
close all;

% dsetName = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';
% dsetName = "../data/MyDsets/ABS/norm";
% dsetName = "C:\Users\Andrew\Desktop\Thesis\ThesisData\PNRroomSimpsons";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\norm";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\rot";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\trans";
dsetName = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\PNRroomSimpsons";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\PNRroomSimpsonsRotated";
% dsetName = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\Digiteo_seq_2\Digiteo_seq_2\Active-Stereo\RGB-D\rgb";
% dsetName = '../data/dum_cloudy1/png';

dset = getDset(dsetName);


trainingSubsetSkip = 5;

% BoF params:5
numLevels = 1;
numBranches = 20000;

% visualiseImagesIndexes = [201, 462,701];
visualiseImagesIndexes = [99,20];

% extractor = @simpleGlobalFeatExtractor;
% extractor = @siftFeatureExtractor;
% extractor = @orbBriefExtractor;
% extractor = @featureSPC;

% if using random lines:
% nLines = 1000;
% sampleDensity = max(dset.imsize);
% lines = generateRandomLines(dset.imsize, 100);
% [xToSample, yToSample] = lines2SamplePoints(lines, 200); % I am speed
% extractor = @(img) maxMinFeaturesAlongCurves(img, xToSample,yToSample);

% using circles
% nCirc = 2000;
% nSamples = 100;
% radiusBounds = [20,50];
% [xToSample, yToSample] = generateCircleSamplesPts(dset.imsize, nCirc, radiusBounds, nSamples);
% extractor = @(img) maxMinFeaturesAlongCurves(img, xToSample,yToSample);

% nCurves = 3000;
% nSamples = 1000;
% radii = [20,50];
% extractor = @(img) maxMinFeaturesAlongUniqueRandCirc(img, nCurves, radii, nSamples);
% % extractor = @(img) maxMinFeaturesAlongUniqueRandLines(img, nCurves, nSamples);

% Using angle vs sum of squared of the first derivative
numLines = 5000;        % Number of random lines to sample
lineLength = 150;       % Length of each line
numBinsFeature = 200;   % Number of bins for feature values
numBinsAngle = 200;     % Number of bins for angles

extractor = @(img) extractHistogramFeatures(img, numLines, lineLength, numBinsFeature, numBinsAngle);


testExtractor(dset, trainingSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor);


