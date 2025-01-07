clear;
clc;
close all;


rng(1);

% dset = getDset('../data/MyDsets/PNRtopWalkthrough1/imgs');
dset = getDset('C:\Users\Andrew\Desktop\Thesis\ThesisData\PNRtopWalkthrough1\imgs')
% dset = getDset('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');


% BoF params:
numLevels = 1;
numBranches = 5000;


visualiseImagesIndexes = [];

nLines = 2e3;
trainSubsetSkip = 20;

nIter = 2;

brightnessFactors = linspace(0.8,1.2,7);
% brightnessFactors = 1;

sampleDensity = max(dset.imsize);
% extractors = {@(img) maxMinFeaturesAlongUniqueRandCirc(img, nLines, [15,50], sampleDensity, false),...
%                      @(img) maxMinFeaturesAlongUniqueRandCirc(img, nLines, [15,50], sampleDensity, true)...
%                      @(img) siftFeatureExtractor(img)};% one for normalise

extractors = {@(img) orbBriefExtractor(img)...
                     @(img) maxMinFeaturesAlongUniqueRandCirc(img, nLines, [15,50], sampleDensity, false),...
                     @(img) maxMinFeaturesAlongUniqueRandCirc(img, nLines, [15,50], sampleDensity, true)...
                     @(img) siftFeatureExtractor(img)};

tic
for etorIdx = 1:length(extractors)
    extractor = extractors{etorIdx};
    acc = zeros(1,length(brightnessFactors));
    tic
    for nIdx = 1:length(brightnessFactors)
        dstore = ATimds(dset.path, brightnessFactors(nIdx));

        acc(nIdx) = testExtractorDstore(dstore, trainSubsetSkip, numLevels, numBranches, visualiseImagesIndexes, extractor, false);
    end
    toc
    hold on
%     ATerrorbar(brightnessFactors, mean(acc), std(acc)/sqrt(nIter));
    ATplot(brightnessFactors,acc);
end
ATprettify();

