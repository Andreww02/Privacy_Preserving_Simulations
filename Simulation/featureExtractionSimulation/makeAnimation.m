% Clear everything
clear;
clc;
close all;

%% Path to image dataset
% dsetPath = "C:\Users\Andrew\Desktop\Thesis\ThesisData\ABS\norm";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\rot";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\trans";
% dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\PNRroomSimpsons";
dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\PNRroomSimpsonsRotated";
% dsetPath = "C:\Users\Andrew\Desktop\Thesis\ThesisData\VerticalLines";
dset = getDset(dsetPath);

%% Parameters for the 2D histogram
numLines       = 10000;  % Number of random lines
lineLength     = 100;     % Length of each line in pixels
numBinsFeature = 100;     % Number of bins for the sum-of-derivatives feature
numBinsAngle   = 100;     % Number of bins for angles (e.g., 0-360 degrees)
numBins = 100;   % Number of bins (5-degree increments)
numSamples = 5000; % Number of random lines

%% Animation settings
startIndex = 5;         % Starting index in your dataset
numFrames  = 150;          % How many consecutive frames (images) to show
pauseTime  = 0.5;         % Pause (in seconds) between frames
stride     = 4;

%% Create and open a VideoWriter object
videoFileName = 'animation_raw_corr_pnr_rot_stride_4.mp4';   % Name of the output video file
videoWriter   = VideoWriter(videoFileName, 'MPEG-4');
videoWriter.FrameRate = 1 / pauseTime;  % Frame rate (based on pauseTime)
open(videoWriter);  % Open the video file for writing

% Create a figure for animation
hFig = figure('Name', '2D Histogram Animation', 'NumberTitle', 'off');
set(hFig, 'Position', [100, 100, 1200, 600]); % Adjust size and position

% Pre-create subplots to avoid clearing the figure each time
subplot1 = subplot(1, 2, 1);
subplot2 = subplot(1, 2, 2);
i = 0;

for idx = startIndex : (startIndex + numFrames - 1)
    
    %--- 1. Retrieve and display the image from the dataset
    img = f_displayImageFromDset(dset, (idx+i));
    
    % Make sure image is grayscale
    if size(img, 3) > 1
        img = rgb2gray(img);
    end
    
    %--- 2. Generate the angles and sum-of-derivatives arrays using your function
    % [angles, sumDerivatives, angleEdges, featureEdges, counts] = f_generateHistogram(img, ...
    %     numLines, lineLength, numBinsFeature, numBinsAngle);
    % [angles, sumSecondDerivatives, angleEdges, featureEdges, counts] = f_generateHistogramSecondDerivative(img, numLines, lineLength, numBinsFeature, numBinsAngle);
    
    [edges, counts] = jointDistributionHeatmap(img, numBins, numSamples);
    % [pixelValue1, pixelValue2, correlations] = correlationHistogram(img, numSamples, numBins); % Analyze 1000 random pairs

    
    %--- 4. Update subplots
    % Update the left subplot with the image
    axes(subplot1);
    imshow(img, []);
    title(sprintf('Image at index = %d', (idx+i)), 'Interpreter', 'none');
    
    % Update the right subplot with the 2D histogram
    axes(subplot2);

    % imagesc(featureEdges(1:end-1), angleEdges(1:end-1), counts');
    % axis xy;
    % colorbar;
    % ylabel('Line Angle (degrees)');
    % xlabel('Normalized Sum of Derivatives');
    % clim([0, 20]);
    % title('2D Heatmap of Normalized Sum of Derivatives and Line Angles');
   
    imagesc(edges(1:end-1), edges(1:end-1), counts');
    axis xy;
    colorbar;
    xlabel('Pixel 1 Intensity'); 
    ylabel('Pixel 2 Intensity');
    clim([0, 20]);
    title('Joint Pixel Intensity Distribution');

    % histogram(correlations, numBins, 'FaceColor', 'b');
    % ylim([0 2000]);
    % xlim([-2e4 2e4]);
    % xlabel('Correlation Value');
    % ylabel('Frequency');
    % title('Histogram of Centered Correlation Between Random Pairs of Points');

    %--- 5. Capture the frame and write to the video
    frame = getframe(hFig);  % Capture the current figure
    writeVideo(videoWriter, frame);  % Write the frame to the video
    
    % Optional: Pause to visualize during execution
    pause(pauseTime);
    i = i+stride;
end

% Close the video file
close(videoWriter);

disp(['Animation saved as: ', videoFileName]);
