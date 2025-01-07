function [features, metrics] = siftFeatureExtractor(img)
    %SIFTFEATUREEXTRACTOR 
    % use matlab sift to generate features
    p = detectSIFTFeatures(img);

    [features,validPts] = extractFeatures(img,p,'Method','SIFT');
    metrics = validPts.Metric;
end

