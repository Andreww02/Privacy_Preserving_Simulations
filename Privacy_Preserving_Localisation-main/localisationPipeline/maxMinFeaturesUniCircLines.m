function [features, metrics] = maxMinFeaturesUniCircLines(img, nCurves, split, radii, nSample)
	assert(split > 0 && split < 1)

	nCirc = round(nCurves*split);
	nLines = nCurves - nCirc;

	% do circles
	[xToSample, yToSample] = generateCircleSamplesPts(size(img), nCirc, radii, nSample);
    [features, metrics] = maxMinFeaturesAlongCurves(img, xToSample,yToSample);

	% do lines
    lines = generateRandomLines(size(img), nLines);
    img = double(img);

    [xToSample, yToSample] = lines2SamplePoints(lines, nSample); 
    interpVals = interp2(img,xToSample,yToSample);

    features = [features; max(interpVals,[],2), min(interpVals,[],2)];
    metrics = [metrics; max(interpVals,[],2) - min(interpVals,[],2)];



    if sum(isnan(features),"all") ~= 0
        figure 
        imshow(img);
    end
    
end