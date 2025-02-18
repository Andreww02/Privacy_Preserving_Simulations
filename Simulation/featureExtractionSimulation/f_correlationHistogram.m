function [pixelValue1, pixelValue2, correlations] = f_correlationHistogram(img, num_samples, num_bins)
    % CORRELATIONHISTOGRAMCENTERED Compute correlation by centering values and multiplying pairs.
    %
    % Inputs:
    %   img      - Input image (grayscale)
    %   numPairs - Number of random pairs to analyze
    %
    % Outputs:
    %   A histogram of the correlation values is displayed.
    
    % Validate input
    if size(img, 3) ~= 1
        error('Input image must be grayscale for this task.');
    end
    
    % Get image dimensions
    [rows, cols] = size(img);
    
    % Initialize correlation values
    correlations = zeros(1, num_samples);
    
    % Randomly select pairs of points
    for i = 1:num_samples
        % Randomly select two points
        row1 = randi(rows);
        col1 = randi(cols);
        row2 = randi(rows);
        col2 = randi(cols);
        
        % Extract pixel values and center them around 0
        pixelValue1 = double(img(row1, col1)) - 128;
        pixelValue2 = double(img(row2, col2)) - 128;
        
        % Compute the correlation-like value by multiplying centered values
        correlations(i) = pixelValue1 * pixelValue2;
    end
    
    % Create a histogram of the correlation values
    figure;
    histogram(correlations, num_bins, 'FaceColor', 'b');
    xlabel('Correlation Value');
    ylabel('Frequency');
    ylim([0 1000]);
    xlim([-2e4 2e4]);
    title('Histogram of Centered Correlation Between Random Pairs of Points');
end
