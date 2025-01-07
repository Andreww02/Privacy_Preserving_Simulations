% clear;
% clc;
% close all;
% 
% %---Load the image---
% % img = imread('cameraman.tif');
% % img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\ABS\norm\imgs\00095.png');
% img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\RGB\007.jpeg');
% img = rgb2gray(img);
% img = double(img);
% figure;
% imshow(img, []);
% hold on;
% 
% %---Get the dimensions of the image---
% [rows, cols] = size(img);
% 
% %---Number of random samples---
% numSamples = 1000;
% 
% %---Initialise arrays to store max and min values---
% maxValues = zeros(1, numSamples);
% minValues = zeros(1, numSamples);
% 
% %---Generate N amount of circles---
% for i = 1:numSamples
%     %---Randomise the center of the circle---
%     centerX = randi([1, cols]);
%     centerY = randi([1, rows]);
% 
%     %---Randomise the radius of the circular path---
%     radius = randi([1, 20]);
% 
%     %---Generate the circle and store the max and min values along the
%     %path---
%     [maxValues(i), minValues(i)] = GenerateCircle(img, centerX, centerY, radius);
% end
% 
% %---Create an evenly spaced vector from 0-255 ---
% binEdges = linspace(0, 255, 256);
% 
% %---Create a 2D heat map of max vs min values---
% [counts, xEdges, yEdges] = histcounts2(maxValues, minValues, binEdges, binEdges);
% 
% 
% %---Plot the heat map---
% figure;
% %---Apply Gaussian blur to the heat map---
% sigma = 5;  % Standard deviation for the Gaussian blur
% blurredCounts = imgaussfilt(counts, sigma);
% imagesc(blurredCounts');
% % colorbar;
% xlabel('Max Intensity Value');
% ylabel('Min Intensity Value');
% title('Circular Pattern Hash');
% xlim([0 255]);
% ylim([0 255]);
% set(gca, 'YDir', 'normal');  % Correct the y-axis direction for imagesc

clear;
clc;
close all;
% 
%---Load the image---
% img = imread('cameraman.tif');
% img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\ABS\norm\imgs\00095.png');
img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\RGB\001.jpeg');
% img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\ABS_raw\DJI_20221022_142207_287.jpg');
% img = double(img);
figure

imshow(img)
axis image

redChannel = double(img(:,:,1));
greenChannel = double(img(:,:,2));
blueChannel = double(img(:,:,3));

hold on;
% 
%---Get the dimensions of the image---
[rows, cols] = size(img);
cols =1600;
maxDimension = max(rows,cols);
% 
%---Number of random samples---
numSamples = 1000;
% 
%---Initialise arrays to store max and min values---
maxRedValues = zeros(1, numSamples);
minRedValues = zeros(1, numSamples);
maxGreenValues = zeros(1, numSamples);
minGreenValues = zeros(1, numSamples);
maxBlueValues = zeros(1, numSamples);
minBlueValues = zeros(1, numSamples);
% 
%---Generate N amount of circles---
for i = 1:numSamples
    %---Randomise the center of the circle---
    centerX = randi([1, cols]);
    centerY = randi([1, rows]);

    %---Randomise the radius of the circular path---
    radius = randi([10, 70]);

    viscircles([centerX, centerY], radius, 'LineWidth', 0.5, 'Color', [rand, rand, rand]);

    %---Generate the circle and store the max and min values along the
    %path---
    [maxRedValues(i), minRedValues(i)] = GenerateCircle(redChannel, centerX, centerY, radius);
    [maxGreenValues(i), minGreenValues(i)] = GenerateCircle(greenChannel, centerX, centerY, radius);
    [maxBlueValues(i), minBlueValues(i)] = GenerateCircle(blueChannel, centerX, centerY, radius);
end

%---Create an evenly spaced vector from 0-255 ---
binEdges = linspace(0, 255, 256);

%---Create a 2D heat map of max vs min values---
[redCounts, xEdges, yEdges] = histcounts2(maxRedValues, minRedValues, binEdges, binEdges);
[greenCounts, ~, ~] = histcounts2(maxGreenValues, minGreenValues, binEdges, binEdges);
[blueCounts, ~, ~] = histcounts2(maxBlueValues, minBlueValues, binEdges, binEdges);


%---Apply Gaussian blur to each channel's heat map---
sigma = 3;
blurredRedCounts = imgaussfilt(redCounts, sigma);
blurredGreenCounts = imgaussfilt(greenCounts, sigma);
blurredBlueCounts = imgaussfilt(blueCounts, sigma);
blurredRedCounts = blurredRedCounts.^0.5;
blurredGreenCounts = blurredGreenCounts.^0.5;
blurredBlueCounts = blurredBlueCounts.^0.5;
% 
% %---Normalize the blurred counts to [0, 1] range---
% blurredRedCounts = blurredRedCounts / max(blurredRedCounts(:));
% blurredGreenCounts = blurredGreenCounts / max(blurredGreenCounts(:));
% blurredBlueCounts = blurredBlueCounts / max(blurredBlueCounts(:));

%---Plot the Red heatmap---
figure;
imagesc(blurredRedCounts');
title('Red Heatmap');
redMap = [linspace(0, 1, 256)', zeros(256, 1), zeros(256, 1)];
colormap(redMap);
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
axis square
% axis image
% I^0.5 --> gamma scaling
%---Plot the Green heatmap---
figure;
imagesc(blurredGreenCounts');
title('Green Heatmap');
greenMap = [zeros(256, 1), linspace(0, 1, 256)', zeros(256, 1)];
colormap(greenMap);
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
axis square
%---Plot the Blue heatmap---
figure;
imagesc(blurredBlueCounts');
title('Blue Heatmap');
blueMap = [zeros(256, 1), zeros(256, 1), linspace(0, 1, 256)'];
colormap(blueMap);
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
axis square
%---Combine the heatmaps into an RGB image---
rgbImage = cat(3, blurredRedCounts, blurredGreenCounts, blurredBlueCounts);
rgbImage = rot90(rgbImage);
%---Plot the combined RGB heatmap---
figure;
imshow(rgbImage);
% set(gca, 'YDir', 'normal');
% set(gca, 'XDir', 'normal');
axis on;
title('Combined RGB Heatmap');
xlabel('Max Intensity Value');
ylabel('Min Intensity Value');
xlim([0 255]);
ylim([0 255]);
axis square