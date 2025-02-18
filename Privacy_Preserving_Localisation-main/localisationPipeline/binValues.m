function binIdx = binValues(values, numBins)
    % Discretize values into `numBins`
    minVal = min(values);
    maxVal = max(values);

    % Avoid division by zero
    if maxVal == minVal
        binIdx = ones(size(values)); % Assign all to the first bin if no variation
    else
        binEdges = linspace(minVal, maxVal, numBins + 1);
        binIdx = discretize(values, binEdges, 'IncludedEdge', 'right');
    end
end
