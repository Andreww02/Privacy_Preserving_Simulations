clear;
clc;
close all;

% dsetFnames = {["../data/MyDsets/PNRroomSimpsonsRotated/imgs"]};
% dsetFnames = {["../data/dum_cloudy1/png"],
%               ["../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb"],
%               ["../data/MyDsets/PNRroomSimpsons/imgs"],
%               ["../data/MyDsets/PNRroomSimpsons/imgs", "../data/MyDsets/PNRroomSimpsonsRotated/imgs"]};

dsetFnames = {["../data/dum_cloudy1/png"],
              ["../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb"],
              ["../data/MyDsets/PNRroomSimpsons/imgs"],
              ["../data/MyDsets/PNRroomSimpsonsRotated/imgs"]};


% dsetFnames = {
%               ["../data/MyDsets/ABS/norm", "../data/MyDsets/ABS/rot"],
%               ["../data/MyDsets/ABS/norm", "../data/MyDsets/ABS/trans"],
%               ["../data/MyDsets/ABS/norm", "../data/MyDsets/ABS/rot_trans"]
%               };

% dsetFnames = {["../data/dum_cloudy1/png"],
%               ["../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb"],
%               ["../data/MyDsets/ABS/norm"],
%               ["../data/MyDsets/ABS/norm", "../data/MyDsets/ABS/rot"],
%               ["../data/MyDsets/ABS/norm", "../data/MyDsets/ABS/trans"],
%               ["../data/MyDsets/ABS/norm", "../data/MyDsets/ABS/rot_trans"]};

dsetNames = {...
            ["dum_cloudy1"],
            ["Digiteo_seq_2"],
            ["PNR"],
            ["PNRrotated"]
                };

% dsetNames = {...
%             ["ABS_norm", "ABS_rot"],
%             ["ABS_norm", "ABS_trans"],
%             ["ABS_norm", "rot_trans"]
%                 };

% dsetNames = {["PNRroomRotated"]};
% dsetNames = {["dum_cloudy1"],
%                         ["Digiteo_seq_2"],
%                         ["PNRroom"],
%                         ["PNRroom", "PNRroomRotated"]};


rng(42)

for tabRow = 1:length(dsetFnames)
    trainDset = getDset(dsetFnames{tabRow}(1));
    trainDset.stride = 20;

    if length(dsetFnames{tabRow}) == 1
        % there is only a train dset
        testDset = trainDset;
        accuracyWidth = 1.5;
    else
        testDset = getDset(dsetFnames{tabRow}(2));
        accuracyWidth = 2.5;
    end
    testDset.stride = 1;

    curveFraction = 300; % number of curves as a fraction of the number of pixels

    minRadiiFrac = 21;
    maxRadiiFrac = 72;

%     minRadiiFrac = 2;
%     maxRadiiFrac = 5;

%     radii = min(trainDset.imsize)./[maxRadiiFrac,minRadiiFrac]
    radii = [15,50];

    nCurves = round(prod(trainDset.imsize)/curveFraction)
    nSamples = max(trainDset.imsize)

    etors = {...
        @siftFeatureExtractor,... 
                  @orbBriefExtractor,...
                  @(img) maxMinFeaturesAlongUniqueRandCirc(img, nCurves, radii, nSamples),...
                  @(img) maxMinFeaturesAlongUniqueRandLines(img, nCurves, nSamples)};

%     lines = generateRandomLines(trainDset.imsize, nCurves);
%     [lineXToSample, lineYToSample] = lines2SamplePoints(lines, nSamples); 
% 
%     [circxToSample, circyToSample] = generateCircleSamplesPts(trainDset.imsize, nCurves, radii, nSamples);
%     etors = {...
%         @siftFeatureExtractor,... 
%                   @orbBriefExtractor,...
%                   @(img) maxMinFeaturesAlongCurves(img, circxToSample,circyToSample),...
%                   @(img) maxMinFeaturesAlongCurves(img, lineXToSample,lineYToSample)};
    etorNames = ["SIFT", "ORB", "Circle extrema", "Line extrema"];


    for etorIdx = 1:length(etors)
        acc(tabRow, etorIdx) = evalExtractor(etors{etorIdx}, trainDset, testDset, accuracyWidth=accuracyWidth);
    end
end

target = fopen('evalOverDifferentDatasets.txt','a+');
fprintf(target, '----------- new exp ----------\n');
fprintf(target,'%s & ',etorNames);
fprintf(target,'\b\b\n');
% target = 1;

for tabRow = 1:length(dsetFnames)
    if length(dsetNames{tabRow}) == 1
        dsetNames{tabRow}(2) = dsetNames{tabRow}(1);
    end
    fprintf(target, '%s & %s & ', dsetNames{tabRow}(1), dsetNames{tabRow}(2));
    for etorIdx = 1:length(etors)
        [~,i] = max(acc(tabRow, etorIdx));
        if etorIdx == i
            fprintf(target, '\\textbf{%.2f}', acc(tabRow, etorIdx)*100);
        else
            fprintf(target, '%.2f', acc(tabRow, etorIdx)*100);
        end
        if etorIdx ~= length(etors)
            fprintf(target, ' & ');
        end
    end
    fprintf(target, '\\\\ \n');
end
fclose(target);