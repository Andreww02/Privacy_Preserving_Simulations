clear;
clc;
close all;

%---Load the image---
% img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\RGB\001.jpeg');
img = imread("C:\Users\Andrew\Desktop\Thesis\ThesisData\PNRroomSimpsons\imgs\00001.png");


img = double(img);  % Convert image to double for calculations

%---Separate the image into Red, Green, and Blue channels---
redChannel = img(:,:,1);
% greenChannel = img(:,:,2);
% blueChannel = img(:,:,3);

%---Display the image---
figure;
imshow(img / 255);  % Display normalized image
title('Original Image with Multiple Sinusoidal Paths');
axis image;
hold on;

%---Get the dimensions of the image---
[rows, cols, ~] = size(img);

%---Parameters for the sinusoidal paths---
numPaths = 200;             % Number of paths
numPointsPerPath = 1000;    % Number of points per path (increased for smoothness)
numSamplesPerPath = 10;     % Number of samples per path segment
amplitudeX = cols / 2;      % Amplitude in the x-direction (covers half the image width)
amplitudeY = rows / 2;      % Amplitude in the y-direction (covers half the image height)
edgeMargin = 10;            % Margin in pixels to define image edges

%---Initialize variables to store all paths---
x_total = zeros(numPaths * numPointsPerPath, 1);  % Preallocate for efficiency
y_total = zeros(numPaths * numPointsPerPath, 1);  % Preallocate for efficiency
currentIndex = 1;  % Initialize index for preallocated arrays

%---Initialize lists to store max and min intensity values---
totalSamples = numPaths * numSamplesPerPath;  % Total number of samples
redMaxList = NaN(totalSamples,1);  % Initialize with NaN for easy filtering
redMinList = NaN(totalSamples,1);
greenMaxList = NaN(totalSamples,1);
greenMinList = NaN(totalSamples,1);
blueMaxList = NaN(totalSamples,1);
blueMinList = NaN(totalSamples,1);

%---Starting point (center of the image)---
currentX = cols / 2;  % Start from the center for balanced coverage
currentY = rows / 2;

%---Define a color map for segments---
colors = lines(numSamplesPerPath);  % Generates a distinct color for each segment

%---Loop to generate multiple continuous sinusoidal paths---
for i = 1:numPaths
    %---Random frequencies for the sinusoidal signals in x and y---
    frequencyX = rand() * 0.25 + 0.01;  % Frequency range for x-direction [0.01, 0.26]
    frequencyY = rand() * 0.25 + 0.01;  % Frequency range for y-direction [0.01, 0.26]
    
    %---Define a parameter t for generating both x and y coordinates---
    numCycles = 5;  % Number of sine cycles per path segment
    t = linspace(0, 2 * pi * numCycles, numPointsPerPath);
    
    %---Generate x and y sinusoidal paths---
    deltaX = amplitudeX * sin(frequencyX * t);
    deltaY = amplitudeY * sin(frequencyY * t);
    
    x = currentX + deltaX;
    y = currentY + deltaY;
    
    %---Ensure points stay within image bounds---
    x = max(1, min(cols, x));
    y = max(1, min(rows, y));
    
    %---Append to total path---
    x_total(currentIndex:currentIndex + numPointsPerPath - 1) = x';
    y_total(currentIndex:currentIndex + numPointsPerPath - 1) = y';
    currentIndex = currentIndex + numPointsPerPath;
    
    %---Divide the path into equal-length segments and sample---
    pointsPerSample = floor(numPointsPerPath / numSamplesPerPath);
    
    for j = 1:numSamplesPerPath
        %---Define the start and end indices for the current segment---
        segmentStart = (j-1)*pointsPerSample + 1;
        if j < numSamplesPerPath
            segmentEnd = j*pointsPerSample;
        else
            segmentEnd = numPointsPerPath;  % Ensure the last segment includes all remaining points
        end
        
        %---Extract the current segment's x and y coordinates---
        segmentX = x(segmentStart:segmentEnd);
        segmentY = y(segmentStart:segmentEnd);
        
        %---Check if the segment is along the image edges---
        isEdgeSegment = (all(segmentX <= edgeMargin) || all(segmentX >= (cols - edgeMargin)) || ...
                         all(segmentY <= edgeMargin) || all(segmentY >= (rows - edgeMargin)));
                     
        if ~isEdgeSegment  % Proceed only if not an edge segment
            %---Extract pixel intensity values from each color channel---
            segmentRed = interp2(redChannel, segmentX, segmentY, 'linear', 0);
            % segmentGreen = interp2(greenChannel, segmentX, segmentY, 'linear', 0);
            % segmentBlue = interp2(blueChannel, segmentX, segmentY, 'linear', 0);
            
            %---Store max and min intensity values for this segment---
            sampleIndex = (i-1)*numSamplesPerPath + j;
            redMaxList(sampleIndex) = max(segmentRed);
            redMinList(sampleIndex) = min(segmentRed);
            % greenMaxList(sampleIndex) = max(segmentGreen);
            % greenMinList(sampleIndex) = min(segmentGreen);
            % blueMaxList(sampleIndex) = max(segmentBlue);
            % blueMinList(sampleIndex) = min(segmentBlue);
            
            %---Plot the current segment with a unique color---
            plot(segmentX, segmentY, 'LineWidth', 1.5, 'Color', colors(j,:));
        else
            %---Optional: Handle edge segments (e.g., mark them differently)---
            % Uncomment the following line if you want to visualize skipped segments
            % plot(segmentX, segmentY, 'LineWidth', 1.5, 'Color', [0.5 0.5 0.5]);  % Gray color for skipped segments
        end
    end
    
    %---Update current position to the end of this path---
    currentX = x(end);
    currentY = y(end);
end

hold off;

%---Filter out NaN samples (edge segments)---
validIdx = ~isnan(redMaxList) & ~isnan(redMinList)
           % ~isnan(greenMaxList) & ~isnan(greenMinList) & ...
           % ~isnan(blueMaxList) & ~isnan(blueMinList);
       
redMaxList = redMaxList(validIdx);
redMinList = redMinList(validIdx);
% greenMaxList = greenMaxList(validIdx);
% greenMinList = greenMinList(validIdx);
% blueMaxList = blueMaxList(validIdx);
% blueMinList = blueMinList(validIdx);

%---Create an evenly spaced vector from 0-255---
binEdges = linspace(0, 255, 256);

%---Create 2D histograms for max vs min values for each color channel---
% Using 'histcounts2' requires Statistics and Machine Learning Toolbox
[redCounts, ~, ~] = histcounts2(redMaxList, redMinList, binEdges, binEdges);
% [greenCounts, ~, ~] = histcounts2(greenMaxList, greenMinList, binEdges, binEdges);
% [blueCounts, ~, ~] = histcounts2(blueMaxList, blueMinList, binEdges, binEdges);

%---Apply Gaussian blur to each channel's heat map---
sigma = 3;
blurredRedCounts = imgaussfilt(redCounts, sigma);
% blurredGreenCounts = imgaussfilt(greenCounts, sigma);
% blurredBlueCounts = imgaussfilt(blueCounts, sigma);

%---Gamma scaling for better visualization---
blurredRedCounts = blurredRedCounts.^0.5;
% blurredGreenCounts = blurredGreenCounts.^0.5;
% blurredBlueCounts = blurredBlueCounts.^0.5;

%---Plot the Red heatmap---
figure;
imagesc(binEdges, binEdges, blurredRedCounts');
title('Red Heatmap');
redMap = [linspace(0, 1, 256)', zeros(256, 1), zeros(256, 1)];
colormap(redMap);
colorbar;
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
axis square;
xlabel('Max Intensity Value');
ylabel('Min Intensity Value');
% 
% %---Plot the Green heatmap---
% figure;
% imagesc(binEdges, binEdges, blurredGreenCounts');
% title('Green Heatmap');
% greenMap = [zeros(256, 1), linspace(0, 1, 256)', zeros(256, 1)];
% colormap(greenMap);
% colorbar;
% xlim([0 255]);
% ylim([0 255]);
% set(gca, 'YDir', 'normal');
% axis square;
% xlabel('Max Intensity Value');
% ylabel('Min Intensity Value');
% 
% %---Plot the Blue heatmap---
% figure;
% imagesc(binEdges, binEdges, blurredBlueCounts');
% title('Blue Heatmap');
% blueMap = [zeros(256, 1), zeros(256, 1), linspace(0, 1, 256)'];
% colormap(blueMap);
% colorbar;
% xlim([0 255]);
% ylim([0 255]);
% set(gca, 'YDir', 'normal');
% axis square;
% xlabel('Max Intensity Value');
% ylabel('Min Intensity Value');

%---Combine the heatmaps into an RGB image---
% Normalize each heatmap before combining to ensure proper color mixing
maxRed = max(blurredRedCounts(:));
% maxGreen = max(blurredGreenCounts(:));
% maxBlue = max(blurredBlueCounts(:));

% Prevent division by zero
if maxRed == 0
    maxRed = 1;
end
% if maxGreen == 0
%     maxGreen = 1;
% end
% if maxBlue == 0
%     maxBlue = 1;
% end

% rgbImage = cat(3, blurredRedCounts / maxRed, blurredGreenCounts / maxGreen, blurredBlueCounts / maxBlue);

%---Flip the RGB heatmap vertically to correct Y-axis orientation---
% rgbImage = rot90(rgbImage);

%---Plot the combined RGB heatmap---
figure;
imshow(rgbImage);
title('Combined RGB Heatmap (Flipped Vertically)');
xlabel('Max Intensity Value');
ylabel('Min Intensity Value');
axis on;
xlim([0 255]);
ylim([0 255]);
axis square;
