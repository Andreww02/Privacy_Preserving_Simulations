clear;
clc;
close all;
addpath 'C:\Users\Adam\Documents\University of Sydney\UNI\Year5\Honours\PrivPresLoc\localisationPipeline'

% imPath = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';
imPath = '../data/dum_cloudy1/png';
% imPath = fullfile('../data/MyDsets\PNRtopWalkthrough1\imgs');
% imPath = fullfile('../data/MyDsets\PNRroomSimpsonsRotated\imgs');
% imPath = fullfile('../data/MyDsets\ABS\rot_trans\');
dset = getDset(imPath);
imageSet = imageDatastore(imPath,'LabelSource','foldernames','IncludeSubfolders',true);



figure
gridSize = [3,2];
idxs = linspace(1,dset.nImgs, gridSize(1)*gridSize(2) + 1);
img = imtile(subset(imageSet, round(idxs(1:end-1))),...
    'GridSize', gridSize, 'BorderSize', 10);
imshow(img)

% imwrite(img, 'cloudy_imtile.png')


