function [features, metrics] = extractHistogramFeatures(img, numLines, lineLength, numBinsFeature, numBinsAngle)
    % Generate random lines
    lines = f_generateRandomLines(size(img), numLines, lineLength);

    % Compute features (sum of squared derivatives) and angles
    [sumDerivatives, angles] = computeLineFeatures(img, lines);

    % Bin features and angles
    % Directly discretize sumDerivatives into `numBinsFeature`
    featureBins = discretize(sumDerivatives, linspace(0, 1, numBinsFeature + 1), 'IncludedEdge', 'right');
    
    % Directly discretize angles into `numBinsAngle`
    angleBins = discretize(angles, linspace(0, 180, numBinsAngle + 1), 'IncludedEdge', 'right');

    % disp(size(featureBins));
    % disp(size(angleBins));
    % Flatten the feature matrix into a 1D row vector
    features = [featureBins', angleBins'];
 
    % Ensure metrics is a column vector
    metrics = max(features, [], 2) - min(features, [], 2);
    % disp("hi");
    % disp(size(features));
    % disp(size(metrics));
end
