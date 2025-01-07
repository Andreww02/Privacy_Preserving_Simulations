% experiment to find the case in the dataset where the normalisation 
clear
clc
close all

imPath = '../data/MyDsets/stills/differentSceneTypes';

dset = getDset(imPath);

imageSet = imageDatastore(imPath,'LabelSource','foldernames','IncludeSubfolders',true);

imgsToRead = 1:length(imageSet.Files);

for imgIdx = 1:length(imgsToRead)
    imgs{imgIdx} = im2gray(readimage(imageSet,imgsToRead(imgIdx)));
end


nCirc = 1e3;
radii = [15,30];
sampleDensity = max(dset.imsize);

extractors = {@(img) maxMinFeaturesAlongUniqueRandCirc(img,nCirc,radii,sampleDensity), ...
                    @(img) maxMinFeaturesAlongUniqueRandLines(img,nCirc,sampleDensity)};


% ax = displayFingerprint(imgs, extractors);
ax = displayFingerprintTranspose(imgs, extractors);
return

boxesY = [1.507,8.07;
                 0.5,56.29;
                 0.5,49;
                 0.5,21];

boxesX = [107.9656  256.5000;
                 120.1340  256.5000;
                 169.8659  256.5000;
                 233.1877  256.5000];


for i = 2:5
    axes(ax(i,3))
    hold on
    [xx,yy] = ATlimitsToCorners(boxesX(i-1,:),boxesY(i-1,:));
    ATplot(xx,yy,'r')
end

