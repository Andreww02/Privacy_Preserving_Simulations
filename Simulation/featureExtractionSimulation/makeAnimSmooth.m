%% animateDatasetSmoothHistogramSave.m
% This script loads all images from the specified dataset folder and creates
% an animation displaying each image alongside its 2D histogram (computed
% with a temporal lowpass filter via f_generateHistogramSmooth). The animation
% is saved to a video file with a 0.2-second interval between frames.

%---- Specify the dataset folder ------------------------------------------
dsetPath = "C:\Users\Andrew\Desktop\Privacy_Preserving_Simulations\ThesisData\ABS\rot\imgs";

% Get a list of image files (adjust extensions as needed).
filesPNG = dir(fullfile(dsetPath, '*.png'));
filesJPG = dir(fullfile(dsetPath, '*.jpg'));
imageFiles = [filesPNG; filesJPG];

if isempty(imageFiles)
    error('No image files found in the specified folder: %s', dsetPath);
end

% Optional: sort the files by name.
[~, sortIdx] = sort({imageFiles.name});
imageFiles = imageFiles(sortIdx);

%---- Set parameters for the histogram -------------------------------------
numLines       = 10000;  % Number of random lines to sample.
lineLength     = 150;   % Length of each random line.
numBinsFeature = 200;  % Number of bins for the normalized feature.
numBinsAngle   = 200;  % Number of bins for the line angle.

%---- Set up figure for the animation --------------------------------------
hFig = figure('Name', 'Dataset Animation with Smooth Histogram', ...
              'NumberTitle', 'off', ...
              'MenuBar', 'none', ...
              'ToolBar', 'none');

% Create two subplots:
% Left: for the input image.
axFeed = subplot(1,2,1);
title(axFeed, 'Input Image');

% Right: for the smooth histogram.
axHist = subplot(1,2,2);
title(axHist, '2D Histogram (Smooth)');

% (Optional) Fix the colorbar range for the histogram display.
fixedCLim = [0 7];  % Adjust these limits as needed.
caxis(axHist, fixedCLim);
% colorbar(axHist);

%---- Set up VideoWriter to save the animation ----------------------------
videoFileName = fullfile(dsetPath, 'animationABS.mp4');  % Video saved in the dataset folder.
writerObj = VideoWriter(videoFileName, 'MPEG-4');
writerObj.FrameRate = 5;  % 5 frames per second equals 0.2 seconds per frame.
open(writerObj);

%---- Loop over each image in the dataset ---------------------------------
for i = 1:length(imageFiles)
    % Build the full file name and read the image.
    filename = fullfile(dsetPath, imageFiles(i).name);
    I = imread(filename);
    
    % Convert to grayscale if needed.
    if size(I,3) == 3
        I = rgb2gray(I);
    end
    
    % Display the image in the left subplot.
    axes(axFeed);
    imshow(I);
    title(axFeed, sprintf('Image: %s', imageFiles(i).name));
    
    % Compute and display the smooth histogram in the right subplot.
    f_generateHistogramSmooth(axHist, I, numLines, lineLength, numBinsFeature, numBinsAngle);
    
    % Update the figure.
    drawnow;
    
    % Pause for 0.2 seconds to simulate the interval.
    pause(0.2);
    
    % Capture the current frame.
    frame = getframe(hFig);
    writeVideo(writerObj, frame);
    
    % If the figure is closed during the loop, break out.
    if ~ishandle(hFig)
        break;
    end
end

%---- Clean up: Close the video file and the figure -----------------------
close(writerObj);
close(hFig);
disp(['Animation saved to: ', videoFileName]);
