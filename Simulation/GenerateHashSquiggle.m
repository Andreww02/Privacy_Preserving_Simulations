% clear;
% clc;
% close all;
% 
% %---Load the image and convert it to double---
% img = imread('cameraman.tif');
% % img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\ABS\norm\imgs\00095.png');
% img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\RGB\001.jpeg');
% img = rgb2gray(img);
% img = double(img);
% 
% % figure;
% % imshow(img, []);
% % hold on;
% 
% 
% %---Parameters for the squiggly lines---
% numLines = 1000;    % Number of squiggly lines
% numPoints = 100; % Number of points in each squiggly line
% amplitude = 10;  % Amplitude of the squiggle (adjust for more or less squiggle)
% frequency = 1;  % Frequency of the squiggle (number of cycles)
% 
% %---Generate a set of colors for the lines---
% colors = lines(numLines);
% 
% %---Get the dimensions of the image---
% [rows, cols] = size(img);
% maxDimension = max(rows,cols);
% 
% %---Initialise arrays to store max and min values---
% maxValues = zeros(1, numLines);
% minValues = zeros(1, numLines);
% 
% %---Initialise starting point---
% X0 = randi([1, cols]); % x direction
% Y0 = randi([1, rows]); % y direction
% 
% %---FOR LOOSPZZZZ---
% for i = 1:numLines
%     % Random length of the squiggly line
%     lineLength = randi([round(0.03*maxDimension), round(0.15*maxDimension)]);  % length range is set to be 3-15% of the max dimension
% 
%     %---Trigonometry---
%     theta = rand() * 2 * pi;  % Random angle in radians
%     X1 = X0 + lineLength * cos(theta);
%     Y1 = Y0 + lineLength * sin(theta);
%     %---Ensure end points are within image bounds (not exceed num of rows or columns---
%     X1 = max(1, min(cols, X1));
%     Y1 = max(1, min(rows, Y1));
% 
%     % Generate intermediate points
%     t = linspace(0, 1, numPoints);  % Parameter for line interpolation
%     x = linspace(X0, X1, numPoints);
%     y = linspace(Y0, Y1, numPoints);
% 
%     % Introduce squiggle by adding a sinusoidal component
%     squiggle = amplitude * sin(2 * pi * frequency * t);  % Adjust frequency for more/less squiggle
% 
%     % Perturb x and y coordinates to create a squiggly effect
%     x = x + squiggle;
%     y = y + squiggle;
% 
%     %---Extract pixel intensity values---
%     intensity_values = interp2(img, x, y, 'linear', 0);  % Interpolate intensity values
% 
%     % plot(x, y, 'LineWidth', 2, 'Color', colors(i, :));
% 
%     %---Find the maximum and minimum intensity values---
%     maxValues(i) = max(intensity_values);
%     minValues(i) = min(intensity_values);
% 
%     %---Update start point for the next line---
%     X0 = X1;
%     Y0 = Y1;
% end
% 
% %---Create a heatmap of max vs min values---
% figure;
% histEdges = linspace(0, 255, 256);
% [counts, xEdges, yEdges] = histcounts2(maxValues, minValues, histEdges, histEdges);
% imagesc(counts');
% % colorbar;
% xlabel('Max Intensity Value');
% ylabel('Min Intensity Value');
% title('Squiggly Pattern Hash');
% xlim([0 255]);
% ylim([0 255]);
% set(gca, 'YDir', 'normal');  % Correct the y-axis direction for imagesc
% 
% 
% 
% 
% 
% 
% 
% 
clear;
clc;
close all;

%---Load the image---
img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\RGB\001.jpeg');
img = double(img);  % Convert image to double for calculations

%---Separate the image into Red, Green, and Blue channels---
redChannel = img(:,:,1);
greenChannel = img(:,:,2);
blueChannel = img(:,:,3);

%---Display the image---
figure;
imshow(img/255);  % Display normalized image
title('Original Image');
axis image;
hold on;
%---Get the dimensions of the image---
[rows, cols, ~] = size(img);
maxDimension = max(rows, cols);

%---Parameters for the squiggly lines---
numLines = 1000;    % Number of squiggly lines
numPoints = 100;    % Number of points in each squiggly line
amplitude = 10;     % Amplitude of the squiggle (adjust for more or less squiggle)
frequency = 1;      % Frequency of the squiggle (number of cycles)

%---Initialize arrays to store max and min values---
maxRedValues = zeros(1, numLines);
minRedValues = zeros(1, numLines);
maxGreenValues = zeros(1, numLines);
minGreenValues = zeros(1, numLines);
maxBlueValues = zeros(1, numLines);
minBlueValues = zeros(1, numLines);

%---Random starting point for the squiggly lines---
X0 = randi([1, cols]);
Y0 = randi([1, rows]);

%---Generate N amount of squiggly lines---
for i = 1:numLines
    %---Random length of the squiggly line---
    lineLength = randi([round(0.06*maxDimension), round(0.15*maxDimension)]);  % length range is set to be 3-15% of the max dimension

    %---Trigonometry to determine direction---
    theta = rand() * 2 * pi;  % Random angle in radians
    X1 = X0 + lineLength * cos(theta);
    Y1 = Y0 + lineLength * sin(theta);

    %---Ensure end points are within image bounds (not exceed number of rows or columns)---
    X1 = max(1, min(cols, X1));
    Y1 = max(1, min(rows, Y1));

    %---Generate intermediate points---
    t = linspace(0, 1, numPoints);  % Parameter for line interpolation
    x = linspace(X0, X1, numPoints);
    y = linspace(Y0, Y1, numPoints);

    %---Introduce squiggle by adding a sinusoidal component---
    squiggle = amplitude * sin(2 * pi * frequency * t);  % Adjust frequency for more/less squiggle

    %---Perturb x and y coordinates to create a squiggly effect---
    x = x + squiggle;
    y = y + squiggle;

    %---Extract pixel intensity values from each color channel---
    redIntensityValues = interp2(redChannel, x, y, 'linear', 0);  % Interpolate intensity values for Red
    greenIntensityValues = interp2(greenChannel, x, y, 'linear', 0);  % Interpolate intensity values for Green
    blueIntensityValues = interp2(blueChannel, x, y, 'linear', 0);  % Interpolate intensity values for Blue

    %---Find the maximum and minimum intensity values for each channel---
    maxRedValues(i) = max(redIntensityValues);
    minRedValues(i) = min(redIntensityValues);
    maxGreenValues(i) = max(greenIntensityValues);
    minGreenValues(i) = min(greenIntensityValues);
    maxBlueValues(i) = max(blueIntensityValues);
    minBlueValues(i) = min(blueIntensityValues);

    plot(x, y, 'LineWidth', 1.5, 'Color', [rand, rand, rand]);

    %---Update start point for the next line---
    X0 = X1;
    Y0 = Y1;
end

%---Create an evenly spaced vector from 0-255---
binEdges = linspace(0, 255, 256);

%---Create a 2D heat map of max vs min values for each color channel---
[redCounts, ~, ~] = histcounts2(maxRedValues, minRedValues, binEdges, binEdges);
[greenCounts, ~, ~] = histcounts2(maxGreenValues, minGreenValues, binEdges, binEdges);
[blueCounts, ~, ~] = histcounts2(maxBlueValues, minBlueValues, binEdges, binEdges);

%---Apply Gaussian blur to each channel's heat map---
sigma = 3;
blurredRedCounts = imgaussfilt(redCounts, sigma);
blurredGreenCounts = imgaussfilt(greenCounts, sigma);
blurredBlueCounts = imgaussfilt(blueCounts, sigma);

%---Gamma scaling for better visualization---
blurredRedCounts = blurredRedCounts.^0.5;
blurredGreenCounts = blurredGreenCounts.^0.5;
blurredBlueCounts = blurredBlueCounts.^0.5;

%---Plot the Red heatmap---
figure;
imagesc(blurredRedCounts');
title('Red Heatmap');
redMap = [linspace(0, 1, 256)', zeros(256, 1), zeros(256, 1)];
colormap(redMap);
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
axis square;

%---Plot the Green heatmap---
figure;
imagesc(blurredGreenCounts');
title('Green Heatmap');
greenMap = [zeros(256, 1), linspace(0, 1, 256)', zeros(256, 1)];
colormap(greenMap);
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
axis square;

%---Plot the Blue heatmap---
figure;
imagesc(blurredBlueCounts');
title('Blue Heatmap');
blueMap = [zeros(256, 1), zeros(256, 1), linspace(0, 1, 256)'];
colormap(blueMap);
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
axis square;

%---Combine the heatmaps into an RGB image---
rgbImage = cat(3, blurredRedCounts, blurredGreenCounts, blurredBlueCounts);
rgbImage = rot90(rgbImage);

%---Plot the combined RGB heatmap---
figure;
imshow(rgbImage);
axis on;
title('Combined RGB Heatmap');
xlabel('Max Intensity Value');
ylabel('Min Intensity Value');
xlim([0 255]);
ylim([0 255]);

axis square;
