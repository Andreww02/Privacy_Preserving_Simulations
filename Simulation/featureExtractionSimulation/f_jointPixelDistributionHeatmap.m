function [edges, counts] = f_jointPixelDistributionHeatmap(img, num_bins, num_samples)
    % Validate input
    if size(img, 3) ~= 1
        error('Input image must be grayscale for this task.');
    end
    
    % Get image dimensions
    [rows, cols] = size(img);
    
    % Initialize correlation values
    pixelValue1 = zeros(1, num_samples);
    pixelValue2 = zeros(1, num_samples);
    
    % Randomly select pairs of points
    for i = 1:num_samples
        % Randomly select two points
        row1 = randi(rows);
        col1 = randi(cols);
        row2 = randi(rows);
        col2 = randi(cols);
        
        % Extract pixel values and center them around 0
        pixelValue1(i) = double(img(row1, col1));
        pixelValue2(i) = double(img(row2, col2));
    end
    
    % Compute 2D histogram
    edges = linspace(0, 255, num_bins + 1);
    counts = histcounts2(pixelValue1, pixelValue2, edges, edges);
    
    % Display as an image
    figure;
    imagesc(edges(1:end-1), edges(1:end-1), counts');
    colorbar;
    axis xy;
    xlabel('Pixel 1 Intensity'); 
    ylabel('Pixel 2 Intensity');
    title('Joint Pixel Intensity Distribution');
end