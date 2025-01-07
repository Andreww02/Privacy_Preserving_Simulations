clear;
clc;
close all;

rng(1);


% dset = getDset('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');
dset = getDset('../data/MyDsets/PNRtopWalkthrough1/imgs');


% BoF params:
numLevels = 1;
numBranches = 5000;

visualiseImagesIndexes = [];


% skipVals = [5,10];
% eTors = {@simpleGlobalFeatExtractor,@siftFeatureExtractor,@orbBriefExtractor};
nLines = round(logspace(2,4,5));
% nLines = round(logspace(1,2,2));
nIter = 3;
% nIter = 2;

trainSubsetSkip = 20;

figure

% now repeat for unique rand lines
acc = zeros(nIter,length(nLines));
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        extractor = @(img) maxMinFeaturesAlongUniqueRandLines(img, nLines(nIdx),sampleDensity);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
hold on
ATerrorbar(nLines, mean(acc), std(acc)/sqrt(nIter));


nCircles= nLines;

radii = [15,50];

% now repeat for unique rand Circ
acc = zeros(nIter,length(nLines));
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        extractor = @(img) maxMinFeaturesAlongUniqueRandCirc(img,  nCircles(nIdx), radii, sampleDensity);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
hold on
ATerrorbar(nLines, mean(acc), std(acc)/sqrt(nIter));

%% now circles & lines
circLineSplit = 0.5;
acc = zeros(nIter,length(nLines));
for nIdx = 1:length(nLines)
    for i = 1:nIter
        sampleDensity = max(dset.imsize);
        extractor = @(img) maxMinFeaturesUniCircLines(img, nCircles(nIdx), circLineSplit, radii, sampleDensity);

        acc(i,nIdx) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
end
hold on
ATerrorbar(nLines, mean(acc), std(acc)/sqrt(nIter));


xlabel('Number of lines')
ylabel('Accuracy')
% legend('Same Lines','Random Lines','Same Circles','Random Circles')
legend('Random Lines','Random Circles','Random Circles and Lines (50/50)')


ylim([0,1])
set(gca,'XScale','log')

% saveas(gcf,'compareRandLines.fig')

%% compare with sift baseline
extractor = @siftFeatureExtractor;
numBranches = 5000;
accSift = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);

hold on
ATplot(xlim,[accSift,accSift],'k--')



numBranches = 25000;

accSift(2) = testExtractor(dset, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);

hold on
ATplot(xlim,[accSift(2),accSift(2)],'m--')
legend('Random Lines','Random Circles','Random Circles and Lines (50/50)', 'SIFT','SIFT(5xbranches)')
saveas(gcf,'compareRandLinesAndCircPNR.fig')
