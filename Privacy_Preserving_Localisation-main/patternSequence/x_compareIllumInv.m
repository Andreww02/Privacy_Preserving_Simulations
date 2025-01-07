% experiment to find the case in the dataset where the normalisation 
clear
clc
close all

imPath = '../data/MyDsets/stills/illumChange';

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
                    @(img) maxMinFeaturesAlongUniqueRandLines(img,nCirc,sampleDensity)...
                    @(img) maxMinFeaturesAlongUniqueRandCirc(img,nCirc,radii,sampleDensity, true), ...
                    @(img) maxMinFeaturesAlongUniqueRandLines(img,nCirc,sampleDensity, true)};


displayFingerprint(imgs, extractors)

