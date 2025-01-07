function [features, metrics] = maxMinFeaturesAlongUniqueRandSinusoidLines(img, nLines, nSample, isNormalise, isMetric)
    arguments
        img (:,:) double
        nLines (1,1) double
        nSample (1,1) double
        isNormalise = false
        isMetric = true
    end


    lines = generateRandomLines(size(img), nLines);

    img = double(img);

    [xToSample, yToSample] = lines2SamplePoints(lines, nSample); 
    interpVals = interp2(img,xToSample,yToSample);

    if isNormalise
        features = [max(interpVals,[],2), min(interpVals,[],2)]/mean(img,"all");
        metrics = [max(interpVals,[],2) - min(interpVals,[],2)]/mean(img,"all");
    else
        features = [max(interpVals,[],2), min(interpVals,[],2)];
        metrics = [max(interpVals,[],2) - min(interpVals,[],2)];
    end

    if ~isMetric
        metrics = ones(size(metrics));
    end

    if sum(isnan(features),"all") ~= 0
        figure 
        imshow(img);
    end
    
end