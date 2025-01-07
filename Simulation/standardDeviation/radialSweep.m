% MATLAB code for pixel analysis in a radial sweeping pattern
clear;
clc;
close all;

% Parameters
image_folder = 'C:\Users\Andrew\Desktop\Thesis\ThesisData\VerticalLines\'; % Path to the image folder
image_prefix = ''; % No prefix, images are numbered directly
image_extension = '.png';
start_frame = 0; % Starting frame number
frame_step = 1; % Step size for frames
num_frames = 250; % Number of frames for the animation
angles = 0:1:359; % Sweep angles in degrees
radius = 500; % Adjust radius as needed

% Prepare storage for standard deviation values for each frame
all_std_values = zeros(num_frames, length(angles));
frames(num_frames) = struct('cdata', [], 'colormap', []); % Preallocate frames for animation

% Create a figure with two subplots
figure;
radial_ax = subplot(1, 2, 1); % Left window for radial sweep
polar_ax = polaraxes('Position', [0.6, 0.1, 0.35, 0.8]); % Right window for polar plot
polarplot(polar_ax, 0, 0, 'b-'); % Initialize polar plot
hold(polar_ax, 'on');
rlim(polar_ax, [0, 1]); % Set fixed axis limits for amplitude

% Process each frame
for frame_idx = 1:num_frames
    frame_number = start_frame + (frame_idx - 1) * frame_step;
    image_name = sprintf('%04d%s', frame_number, image_extension); % Format frame number to 5 digits
    img_path = fullfile(image_folder, image_name);
    
    % Load the image
    img = imread(img_path);
    if size(img, 3) == 3
        img = rgb2gray(img); % Convert to grayscale if the image is in color
    end
    % % Adjust Brightness
    % img  = img + 102;
    
    [rows, cols] = size(img); % Get image dimensions
    center = [round(rows/2), round(cols/2)]; % Center point of the image
    std_values = zeros(size(angles)); % Preallocate standard deviation array

    % Radial sweeping
    cla(radial_ax); % Clear the radial sweep axis
    imshow(img, [], 'Parent', radial_ax); % Display image in the correct axes
    hold(radial_ax, 'on');
    for i = 1:length(angles)
        angle = angles(i); % Current angle in degrees
        rad_angle = deg2rad(angle); % Convert angle to radians

        % Generate line of points from center to the right for the given radius
        x = linspace(center(2), center(2) + radius * cos(rad_angle), radius);
        y = linspace(center(1), center(1) - radius * sin(rad_angle), radius);

        % Ensure coordinates are within bounds
        x = round(x); y = round(y);
        valid_indices = (x > 0 & x <= cols & y > 0 & y <= rows);
        x = x(valid_indices);
        y = y(valid_indices);

        % Extract pixel values along the line
        pixel_values = diag(img(y, x));

        % Calculate standard deviation
        std_values(i) = std(double(pixel_values));

        % Draw the radial line on the image
        plot(radial_ax, x, y, 'r-');
    end
    hold(radial_ax, 'off');

    % Store standard deviation values for this frame
    all_std_values(frame_idx, :) = std_values;

    % Update the polar plot
    cla(polar_ax); % Clear existing lines in the polar plot
    polarplot(polar_ax, deg2rad(angles), std_values, 'b-');
    rlim(polar_ax, [0, 100]); % Maintain fixed axis limits for amplitude
    title(polar_ax, 'Standard Deviation of Pixel Values vs Angle');

    % Capture frame for animation
    frames(frame_idx) = getframe(gcf);
end

% Save animation
video_filename = 'radial_sweep_animation_verticalLines.mp4';
video = VideoWriter(video_filename, 'MPEG-4');
video.FrameRate = 10; % Set frame rate
open(video);
writeVideo(video, frames);
close(video);

disp(['Animation saved to ', video_filename]);