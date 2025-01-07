clear;
clc;
close all;

%---Load your custom grayscale image---
% Ensure the image is grayscale. If not, convert it.
% % % img = imread('C:\Users\Andrew\Desktop\Thesis\ThesisData\Grayscale\your_image.jpeg');
% img = double(img);  % Convert image to double for calculations
img = imread('cameraman.tif');

%---Display the image---
figure;
imshow(img);
% imshow(img / max(img(:)));  % Normalize for display
title('Original Grayscale Image');
axis image;
hold on;
img = double(img); 
%---Get the dimensions of the image---
[rows, cols] = size(img);
maxDimension = max(rows, cols);

%---Parameters for the squiggly lines---
numLines = 3;          % Changed from 1000 to 3
numPoints = 100;       % Number of points in each squiggly line
amplitude = 10;        % Amplitude of the squiggle
frequency = 1;         % Frequency of the squiggle

%---Initialize arrays to store max and min values---
maxValues = zeros(1, numLines);
minValues = zeros(1, numLines);
pixelData = cell(1, numLines);  % Cell array to store pixel values

%---Define Colors for the 3 lines---
colors = {'r', 'g', 'b'};  % 1: Red, 2: Green, 3: Blue

%---Random starting point for the squiggly lines---
X0 = randi([1, cols]);
Y0 = randi([1, rows]);

%---Generate 3 squiggly lines---
for i = 1:numLines
    %---Random length of the squiggly line---
    lineLength = randi([round(0.16 * maxDimension), round(0.45 * maxDimension)]);  % 3-15% of max dimension

    %---Trigonometry to determine direction---
    theta = rand() * 2 * pi;  % Random angle in radians
    X1 = X0 + lineLength * cos(theta);
    Y1 = Y0 + lineLength * sin(theta);

    %---Ensure end points are within image bounds---
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

    %---Extract pixel intensity values from grayscale channel---
    intensityValues = interp2(img, x, y, 'linear', 0);  % Interpolate intensity values

    %---Find the maximum and minimum intensity values---
    maxValues(i) = max(intensityValues);
    minValues(i) = min(intensityValues);
    pixelData{i} = intensityValues;  % Store for distribution plots

    %---Plot the squiggly line in corresponding color---
    plot(x, y, 'LineWidth', 1.5, 'Color', colors{i});

    %---Update start point for the next line---
    X0 = X1;
    Y0 = Y1;
end

hold off;

%---Create an evenly spaced vector from 0-255---
binEdges = linspace(0, 255, 256);

%---Create a 2D heat map of max vs min values---
counts = histcounts2(maxValues, minValues, binEdges, binEdges);

%---Apply Gaussian blur---
sigma = 3;
blurredCounts = imgaussfilt(counts, sigma);

%---Gamma scaling for better visualization---
blurredCounts = blurredCounts.^0.5;

%---Plot the Heatmap---
figure;
imagesc(blurredCounts');
title('Grayscale Heatmap');
colormap('gray');
colorbar;  % Add colorbar for reference
xlim([0 255]);
ylim([0 255]);
set(gca, 'YDir', 'normal');
xlabel('Max Intensity Value');
ylabel('Min Intensity Value');
axis square;
%---Plot All Pixel Value Distributions on a Single Plot with Normalized Distance---
figure;
hold on;

for i = 1:numLines
    normalizedDistance = linspace(0, 1, length(pixelData{i}));  % Normalized distance from 0 to 1
    % Plot pixel intensity values
    plot(normalizedDistance, pixelData{i}, '-', 'Color', colors{i}, 'LineWidth', 1.5, ...
        'DisplayName', ['Line ' num2str(i) ' Intensity']);
    
    % Plot max intensity line
    plot(normalizedDistance, maxValues(i)*ones(1, length(normalizedDistance)), '--', ...
        'Color', colors{i}, 'LineWidth', 1.5, 'HandleVisibility', 'off');
    
    % Plot min intensity line
    plot(normalizedDistance, minValues(i)*ones(1, length(normalizedDistance)), '--', ...
        'Color', colors{i}, 'LineWidth', 1.5, 'HandleVisibility', 'off');
end

hold off;
title('Intensity Distributions of All Lines');
xlabel('Normalized Distance Along Line');
ylabel('Intensity');
legend('show');
grid on;
ylim([0 255]);  % Assuming 8-bit grayscale image

%---Plot Extrema as Scatter Points---
figure;
hold on;
for i = 1:numLines
    scatter(maxValues(i), minValues(i), 100, colors{i}, 'filled', 'DisplayName', ['Line ' num2str(i)]);
end
hold off;
title('Max vs Min Intensity Values for Each Line');
xlabel('Max Intensity Value');
ylabel('Min Intensity Value');
xlim([0 255]);
ylim([0 255]);
legend('show');
grid on;
axis square;
