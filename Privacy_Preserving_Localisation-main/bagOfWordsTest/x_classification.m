% https://au.mathworks.com/help/vision/ug/image-classification-with-bag-of-visual-words.html

clear;
clc;

unzip('MerchData.zip');

imds = imageDatastore('MerchData','IncludeSubfolders',true,'LabelSource','foldernames');

tbl = countEachLabel(imds)

figure
montage(imds.Files(1:16:end))

[trainingSet, validationSet] = splitEachLabel(imds, 0.6, 'randomize');


bag = bagOfFeatures(trainingSet);


img = readimage(imds, 1);
featureVector = encode(bag, img);

categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);
confMatrix = evaluate(categoryClassifier, trainingSet);

confMatrix = evaluate(categoryClassifier, validationSet);

img = imread(fullfile('MerchData','MathWorks Cap','Hat_0.jpg'));
figure
imshow(img)
[labelIdx, scores] = predict(categoryClassifier, img);

categoryClassifier.Labels(labelIdx)