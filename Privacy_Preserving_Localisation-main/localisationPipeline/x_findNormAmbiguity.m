% experiment to find the case in the dataset where the normalisation 
clear
clc
close all


dset = getDset('../data/MyDsets/PNRroomSimpsons/imgs');

imageSet = imageDatastore(dset.path,'LabelSource','foldernames','IncludeSubfolders',true);

imgsToRead = [1,600];

for imgIdx = 1:length(imgsToRead)
    imgs{imgIdx} = readimage(imageSet,imgsToRead(imgIdx));
end

nCirc = 1e3;
radii = [15,50];
sampleDensity = max(dset.imsize);
extractors = {@(img) maxMinFeaturesAlongUniqueRandCirc(img,nCirc,radii,sampleDensity), ...
                    @(img) maxMinFeaturesAlongUniqueRandLines(img,nCirc,sampleDensity)};

displayFingerprint(imgs, extractors)

