clear;
clc;
close all;


dsetName = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';

dset = getDset(dsetName);


imageSet = imageDatastore(dset.path,'LabelSource','foldernames','IncludeSubfolders',true);


img = readimage(imageSet, 100);

cVals = 'rgb';



[feat,metric] = simpleGlobalFeatExtractor(img);
plot(feat(:,1), feat(:,2),'r.')
hold on

sampleDensity = max(dset.imsize);
lines = generateRandomLines(dset.imsize, 2000);
[xToSample, yToSample] = lines2SamplePoints(lines, sampleDensity); % I am speed
[feat,metric] = maxMinFeaturesAlongLines(img, xToSample,yToSample);

plot(feat(:,1), feat(:,2),'g.')

xlabel('max')
ylabel('min')
xlim([0,255])
ylim([0,255])


figure
imshow(img)

