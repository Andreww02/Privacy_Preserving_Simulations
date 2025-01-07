clear;
clc;
close all;

% Parameters
num_bins = 72; % Number of bins (e.g., 72 for 5-degree increments)
bin_width = 360 / num_bins; % Width of each bin in degrees
line_length = 700; % Length of the random line in pixels

% Load and preprocess the image
% image_path = 'C:\Users\Andrew\Desktop\Thesis\ThesisData\PNRroomSimpsons\imgs\00740.png'; % Path to the image
image_path = 'C:\Users\Andrew\Desktop\Thesis\ThesisData\VerticalLines\0212.png'; 
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

% Generate random lines and analyze the image
num_samples = 2500; % Number of random line samples
std_values = zeros(1, num_samples);
angles = zeros(1, num_samples);

figure;
imshow(img, []); % Display the image
hold on; % Hold on to overlay the lines

for sample_idx = 1:num_samples
    % Generate a random starting point
    start_point = [randi(rows), randi(cols)];
    
    % Generate a random angle
    angle = rand() * 360; % Random angle in degrees (0-359)
    angles(sample_idx) = angle;

    % Calculate the end point based on the line length and angle
    dx = line_length * cosd(angle);
    dy = line_length * sind(angle);
    end_point = round([start_point(1) + dy, start_point(2) + dx]);
    
    % Ensure the end point is within image bounds
    end_point(1) = max(1, min(rows, end_point(1)));
    end_point(2) = max(1, min(cols, end_point(2)));

    % Extract pixel values along the line between the start and end points
    line_profile = improfile(img, [start_point(2), end_point(2)], [start_point(1), end_point(1)]);
    
    % Calculate the standard deviation of the pixel values
    std_values(sample_idx) = std(double(line_profile));

    % Visualize the first 5 lines
    if sample_idx <= 5
        plot([start_point(2), end_point(2)], [start_point(1), end_point(1)], 'r-', 'LineWidth', 2);
    end
end
hold off;

% Bin the angles and calculate the average standard deviation for each bin
for i = 1:num_bins
    % Find indices of angles falling into the current bin
    bin_indices = (angles >= bin_edges(i)) & (angles < bin_edges(i+1));

    % Average the standard deviation values for the current bin
    if any(bin_indices) % Check if there are values in the bin
        averaged_std(i) = mean(std_values(bin_indices));
        angle_counts(i) = sum(bin_indices);
    else
        averaged_std(i) = NaN; % Assign NaN if no values in the bin
    end
end

% Plot the results
figure;
bar(binned_angles, averaged_std, 'FaceColor', [0.2 0.6 0.8]);
xlabel('Angle (degrees)');
ylabel('Average Standard Deviation');
title('Average Standard Deviation vs Angle');
grid on;
set(gca, 'XTick', 0:30:360);

% Apply Gaussian filter to the binned averaged standard deviations
sigma = 0.75; % Standard deviation for Gaussian smoothing
smoothed_averaged_std = imgaussfilt(averaged_std, sigma);

% Plot the results
figure;
bar(binned_angles, smoothed_averaged_std, 'FaceColor', [0.2 0.6 0.8]);
xlabel('Angle (degrees)');
ylabel('Smoothed Average Standard Deviation');
title('Smoothed Average Standard Deviation vs Angle');
grid on;
set(gca, 'XTick', 0:30:360);


% Convert angles to radians
angles_rad = deg2rad(binned_angles);

% Plot the results in a polar plot
figure;
polarplot(angles_rad, smoothed_averaged_std, 'LineWidth', 2);
title('Smoothed Average Standard Deviation vs Angle (Polar Plot)');
rlim(polar_ax, [0, 100]);
ax = gca;
ax.ThetaTick = 0:30:360; % Set angular ticks every 30 degrees
ax.ThetaTickLabel = arrayfun(@num2str, 0:30:360, 'UniformOutput', false); % Label in degrees
grid on;
