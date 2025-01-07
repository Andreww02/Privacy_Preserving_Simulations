function [keypoints,descriptors] = computeSIFTKeypointsAndDescriptors(img, sigma, nIntervals, assumedBlur, imgBorderWidth, doSubpixel)
    % Find SIFT features [Lowe 2004]
    % following pySIFT implementation as base version
    % https://github.com/rmislam/PythonSIFT/blob/master/pysift.py


%     assert(min(img,[],'all') >= 0 && max(img,[],'all') <= 1)

    DEBUG = true;


    %%%%%% Part 1: Generate DoG %%%%%%
    % generate the very base image by resizing to double the size
%     baseImg = generateBaseImg(img, sigma, assumedBlur);
    baseImg = img;
    % calculate the number of octaves
%     nOct = computeNumberOfOctaves(size(baseImg));
    nOct = 2;
    % generate the sigma differences for the filters that are successively
    % applied
    gSigmas = generateGaussianSigmas(sigma, nIntervals);
    % generate stack of gaussian images
    gImgs = generateGaussianImages(baseImg, nOct, gSigmas);
    if DEBUG
        figure 
        LFDispMousePan(permute(gImgs{1},[3,1,2]));
    end
    % compute difference of gaussian in each stack
    DoGstack = generateDoG(gImgs);
    if DEBUG
        figure 
        LFDispMousePan(permute(DoGstack{1},[3,1,2]));
    end

    %%%%%% Part 2: find keypoints %%%%%%
    contrastThreshold = 0.08;
    keypoints = findScaleSpaceExtrema(gImgs, DoGstack, nIntervals, sigma, imgBorderWidth, contrastThreshold,doSubpixel);

    


    descriptors = 0;

end

