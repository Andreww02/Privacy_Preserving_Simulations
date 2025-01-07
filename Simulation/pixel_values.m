clear;
clc;
close all;

%---Load the grayscale image---
% If your image is already in grayscale, use imread directly.
% If it's in RGB, convert it to grayscale.

% Uncomment one of the following lines based on your image format:

% For grayscale image:
% img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\Grayscale\001_gray.jpeg');

% For RGB image (convert to grayscale):
% imgRGB = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\RGB\001.jpeg');
% img = rgb2gray(imgRGB);  % Convert RGB to grayscale
img = imread('cameraman.tif');

% Display the original image with 3 random circles
figure;
imshow(img);
axis image;
title('Original Grayscale Image with 3 Random Circles');
hold on;

%---Extract the grayscale channel---
grayChannel = double(img);  % Convert to double for processing

%---Get the dimensions of the image---
[rows, cols] = size(img);

%---Number of random circles---
numCircles = 3;

%---Define Colors for Circles and Plots---
colors = {'r', 'g', 'b'};  % 1: Red, 2: Green, 3: Blue

%---Initialize arrays to store circle parameters and extrema---
centers = zeros(numCircles, 2);  % Each row: [centerX, centerY]
radii = zeros(1, numCircles);
maxValues = zeros(1, numCircles);
minValues = zeros(1, numCircles);
pixelData = cell(1, numCircles);  % Cell array to store pixel values

%---Generate and plot 3 random circles---
for i = 1:numCircles
    %---Randomize the center of the circle---
    centerX = randi([50, cols-50]);  % Avoid circles too close to edges
    centerY = randi([50, rows-50]);
    centers(i, :) = [centerX, centerY];
    
    %---Randomize the radius of the circular path---
    radius = randi([5, 50]);  % Adjust radius range as needed
    radii(i) = radius;
    
    %---Plot the circle with specified color---
    viscircles([centerX, centerY], radius, 'LineWidth', 1.5, 'Color', colors{i});
    
    %---Generate the circle and store the max and min values along the path---
    [maxValues(i), minValues(i), pixelValues] = GenerateCircle(grayChannel, centerX, centerY, radius);
    
    %---Store pixel values for distribution plots---
    pixelData{i} = pixelValues;
end

hold off;

%---Function to generate circle and extract max/min values---
function [maxVal, minVal, pixelValues] = GenerateCircle(channel, centerX, centerY, radius)
    theta = linspace(0, 2*pi, 360);  % 1-degree resolution
    x = centerX + radius * cos(theta);
    y = centerY + radius * sin(theta);
    
    % Ensure coordinates are within image boundaries
    x = round(max(1, min(x, size(channel, 2))));
    y = round(max(1, min(y, size(channel, 1))));
    
    % Extract pixel values along the circle
    linearIndices = sub2ind(size(channel), y, x);
    pixelValues = channel(linearIndices);
    
    % Find global maxima and minima
    maxVal = max(pixelValues);
    minVal = min(pixelValues);
end

%---Plot Pixel Value Distributions for Each Circle---

%---Plot All Pixel Value Distributions on a Single Plot---

figure;
hold on;  % Allow multiple plots on the same figure

for i = 1:numCircles
    thetaDegrees = linspace(0, 360, length(pixelData{i}));  % Degrees
    % Plot pixel intensity values
    plot(thetaDegrees, pixelData{i}, '-', 'Color', colors{i}, 'LineWidth', 1.5, ...
        'DisplayName', ['Circle ' num2str(i) ' Pixel Values']);
    
    % Plot max intensity line
    plot(thetaDegrees, maxValues(i)*ones(1, length(thetaDegrees)), '--', ...
        'Color', colors{i}, 'LineWidth', 1.5, 'HandleVisibility', 'off');
    
    % Plot min intensity line
    plot(thetaDegrees, minValues(i)*ones(1, length(thetaDegrees)), '--', ...
        'Color', colors{i}, 'LineWidth', 1.5, 'HandleVisibility', 'off');
end

hold off;
title('Intensity Distributions of All Circles');
xlabel('Angle (degrees)');
ylabel('Intensity');
legend('show');
grid on;
ylim([0 255]);  % Assuming 8-bit grayscale image


%---Alternative: Plot Extrema as Scatter Points---

figure;
hold on;
for i = 1:numCircles
    scatter(maxValues(i), minValues(i), 100, colors{i}, 'filled', 'DisplayName', ['Circle ' num2str(i)]);
end
hold off;
title('Max vs Min Intensity Values for Each Circle');
xlabel('Max Intensity Value');
ylabel('Min Intensity Value');
xlim([0 255]);
ylim([0 255]);
legend('show');
grid on;
axis square;

