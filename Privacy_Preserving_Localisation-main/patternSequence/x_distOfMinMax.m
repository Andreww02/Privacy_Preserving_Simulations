clear;
clc;
close all;

dset = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';

trainingSubsetSkip = 40;

imageSet = imageDatastore(dset,'LabelSource','foldernames','IncludeSubfolders',true);
imageSubSet = subset(imageSet,1:trainingSubsetSkip:numel(imageSet.Files));



img = readimage(imageSet, 100);

[features, metrics] = maxMinFeaturesAlongUniqueRandLines(img, 2e3, 100);


plot(features(:,1), features(:,2),'r.')
xlim([0,255])
ylim([0,255])

figure
[x1,x2] = meshgrid(0:255, 0:255);
x1 = x1(:);
x2 = x2(:);
xi = [x1 x2];
[f,xi] = ksdensity(features,xi);
imagesc(0:255,0:255,reshape(f,[256,256]))
set(gca,'YDir','normal')

figure
imshow(img)



