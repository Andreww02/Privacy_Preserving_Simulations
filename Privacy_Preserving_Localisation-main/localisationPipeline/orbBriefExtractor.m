function [features, metrics] = orbBriefExtractor(img)
    % orbBriefExtractor 
    p = detectORBFeatures(img);
    if isempty(p)
        figure
        imshow(img)
        features = ones(1,32);
        metrics = 1;
    else
        [f,validPts] = extractFeatures(img,p);
        features = double(f.Features);
        metrics = validPts.Metric;
    end


end

