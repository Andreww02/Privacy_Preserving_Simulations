%% liveDemoHistogram.m
% Live demo for generating a 2D histogram (heatmap) with temporal smoothing
% from webcam images in real time.
%
% This script uses the Image Acquisition Toolbox (videoinput, getsnapshot, etc.)
% to capture frames from the webcam and then computes a histogram using the
% f_generateHistogramSmooth function.
%
% Adjust the videoinput parameters (adaptor, device ID, format, etc.) as needed
% (use imaqtool or imageAcquisitionExplorer to verify your setup).

%----- Stop any previous video stream ------------------------------------
if exist('vid','var')
    stop(vid);
    delete(vid);
end
clearvars;

%----- Configure the webcam using imaq ------------------------------------
% Adjust the adaptor ('winvideo'), device ID (2), and format as needed.
try
    vid = videoinput("winvideo", 2, "MJPG_1280x720");
catch ME
    error('Failed to initialize videoinput. Please check your camera setup and imaqtool settings.\nError: %s', ME.message);
end

src = getselectedsource(vid);
vid.FramesPerTrigger = 1;
vid.ReturnedColorspace = "grayscale";  % Capture grayscale images.
src.FrameRate = '30.0000';

% Use manual trigger mode (but we will rely on getsnapshot, which handles triggering)
triggerconfig(vid, 'manual');
start(vid);

%----- Set up figure windows for live display ----------------------------
hFig = figure('Name', 'Real-Time Histogram Demo (Smoothed)', ...
              'NumberTitle', 'off', ...
              'MenuBar', 'none', ...
              'ToolBar', 'none');

% Left subplot for the camera feed.
hAxFeed = subplot(1,2,1);
title(hAxFeed, 'Camera Feed');

% Right subplot for the histogram.
hAxHist = subplot(1,2,2);
title(hAxHist, '2D Histogram (Smoothed)');

%----- Parameters for histogram generation -------------------------------
numLines       = 2500;  % Number of random lines to sample.
lineLength     = 150;   % Length of each random line.
numBinsFeature = 200;   % Number of bins for the normalized feature.
numBinsAngle   = 200;   % Number of bins for the line angle.

%----- Main Loop: Capture frames and update displays -----------------------
try
    while ishandle(hFig)
        % Capture a frame from the webcam.
        I = getsnapshot(vid);
        
        % Display the camera feed.
        axes(hAxFeed); %#ok<LAXES>
        imshow(I);
        title(hAxFeed, 'Camera Feed');
        
        % Compute and display the histogram with temporal smoothing.
        % f_generateHistogramSmooth will update its internal state so that the
        % histogram changes smoothly from frame to frame.
        f_generateHistogramSmooth(hAxHist, I, numLines, lineLength, numBinsFeature, numBinsAngle);
        
        drawnow;  % Force update of the figure window.
    end
catch ME
    disp('An error occurred during the live demo:');
    disp(ME.message);
end

%----- Clean up: Stop and delete the video stream -------------------------
stop(vid);
delete(vid);
clear vid;
