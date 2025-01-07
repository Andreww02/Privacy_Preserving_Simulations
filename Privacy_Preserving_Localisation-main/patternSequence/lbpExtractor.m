function [features, metrics] = lbpExtractor(img)
    % local binary pattern extractor 
    % issue is it has no metrics
    features = extractLBPFeatures(img);
    metrics = ones(size(features,1));
end

