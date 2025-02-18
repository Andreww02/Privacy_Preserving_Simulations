
clear;
clc;
close all;

% Parameters
num_bins = 60; % Number of bins (e.g., 72 for 5-degree increments)
bin_width = 360 / num_bins; % Width of each bin in degrees

% Load and preprocess the image
image_path = 'C:\Users\Andrew\Desktop\Thesis\ThesisData\VerticalLines\0212.png'; % Path to the image
img = imread(image_path);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is in color
end
[rows, cols] = size(img); % Image dimensions

% Initialize bins and storage
bin_edges = 0:bin_width:360; % Edges of the bins
binned_angles = (bin_edges(1:end-1) + bin_edges(2:end)) / 2; % Bin centers
averaged_std = zeros(1, num_bins); % Preallocate for averaged standard deviations
angle_counts = zeros(1, num_bins); % Count of samples per bin

% Generate random points and analyze the image
num_samples = 2000; % Number of random line samples
std_values = zeros(1, num_samples);
angles = zeros(1, num_samples);

% Create figure for animation
figure;
subplot(1, 2, 1); % Left window for the image and lines
imshow(img, []);
hold on;
title('Image with Sampled Lines');
line_plot = plot(NaN, NaN, 'r-', 'LineWidth', 2); % Placeholder for lines

subplot(1, 2, 2); % Right window for the polar plot
title('Polar Plot of Standard Deviation');
polar_axes = polaraxes;
hold on;
polar_line = animatedline('LineWidth', 2, 'Color', [0.2 0.6 0.8]);
theta = linspace(0, 2*pi, num_bins + 1);

% Animation loop
for sample_idx = 1:num_samples
    % Select two random points in the image
    point1 = [randi(rows), randi(cols)];
    point2 = [randi(rows), randi(cols)];

    % Calculate the angle between the two points
    dy = point2(1) - point1(1);
    dx = point2(2) - point1(2);
    angle = mod(atan2d(dy, dx), 360); % Angle in degrees (0-359)
    angles(sample_idx) = angle;

    % Extract pixel values along the line between the two points
    line_profile = improfile(img, [point1(2), point2(2)], [point1(1), point2(1)]);

    % Calculate the standard deviation of the pixel values
    std_values(sample_idx) = std(double(line_profile));

    % Update bins
    bin_idx = find(angle >= bin_edges(1:end-1) & angle < bin_edges(2:end), 1);
    if ~isempty(bin_idx)
        angle_counts(bin_idx) = angle_counts(bin_idx) + 1;
        averaged_std(bin_idx) = mean(std_values(angles >= bin_edges(bin_idx) & angles < bin_edges(bin_idx + 1)));
    end

    % Update image display with sampled line
    set(line_plot, 'XData', [point1(2), point2(2)], 'YData', [point1(1), point2(1)]);

    % Update polar plot
    polar_data = [averaged_std, averaged_std(1)]; % Wrap data for polar plot
    clearpoints(polar_line);
    addpoints(polar_line, theta, polar_data);

    % Pause for animation effect
    drawnow;
    pause(0.01); % Adjust for desired animation speed
end
