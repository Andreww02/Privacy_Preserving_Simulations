function [angles, sumDerivatives] = f_generateHistogram(img, numLines, lineLength, numBinsFeature, numBinsAngle)
    % Generate a 2D heatmap of normalized derivative sums and line angles.
    %
    % Inputs:
    %   img            - Input image (grayscale)
    %   numLines       - Number of random lines to sample
    %   lineLength     - Length of each random line
    %   numBinsFeature - Number of bins for the feature (sum of derivatives)
    %   numBinsAngle   - Number of bins for the line angle
    %
    % Outputs:
    %   A 2D heatmap is displayed.

    % Validate inputs
    if size(img, 3) ~= 1
        error('Input image must be grayscale.');
    end

    % Get image size
    imgSize = size(img);

    % Generate random lines
    lines = f_generateRandomLines(imgSize, numLines, lineLength);

    % Initialize arrays for sum of derivatives and angles
    sumDerivatives = zeros(1, numLines);
    angles = zeros(1, numLines);

    % Compute the sum of the square of derivatives and angle for each line
    for i = 1:numLines
        % Extract line endpoints
        startPt = lines(i).start;
        endPt = lines(i).end;

        % Generate line coordinates
        [lineX, lineY] = bresenham(startPt(1), startPt(2), endPt(1), endPt(2));

        % Ensure line coordinates are within image bounds
        lineX = min(max(lineX, 1), imgSize(2));
        lineY = min(max(lineY, 1), imgSize(1));

        % Extract pixel intensities along the line
        pixelValues = img(sub2ind(imgSize, lineY, lineX));

        % Compute first derivatives
        derivatives = diff(pixelValues);

        % Compute sum of the squares of derivatives
        sumDerivatives(i) = sum(derivatives.^2);

        % Compute the angle of the line in degrees
        dx = endPt(1) - startPt(1);
        dy = endPt(2) - startPt(2);
        angles(i) = atan2d(dy, dx);
    end

    % Normalize the sum of derivatives to range [0, 1]
    sumDerivatives = (sumDerivatives - min(sumDerivatives)) / (max(sumDerivatives) - min(sumDerivatives));
    % sumDerivatives = sumDerivatives / max(sumDerivatives);

    % Normalize angles to range [0, 360]
    angles = mod(angles, 360);

    % Create bin edges for features and angles
    featureEdges = linspace(0, 1, numBinsFeature + 1);
    angleEdges = linspace(0, 360, numBinsAngle + 1);

    % Create a 2D histogram
    counts = histcounts2(sumDerivatives, angles, featureEdges, angleEdges);

    % Plot the 2D heatmap
    figure;
    imagesc(angleEdges(1:end-1), featureEdges(1:end-1), counts');
    axis xy;
    colorbar;
    xlabel('Line Angle (degrees)');
    ylabel('Normalized Sum of Derivatives');
    title('2D Heatmap of Normalized Sum of Derivatives and Line Angles');
    
    sigma = 1; % Standard deviation for Gaussian kernel
    kernel = fspecial('gaussian', [3 3], sigma);
    counts = imfilter(counts, kernel, 'same');

    % Plot the 2D heatmap
    figure;
    imagesc(angleEdges(1:end-1), featureEdges(1:end-1), counts');
    axis xy;
    colorbar;
    xlabel('Line Angle (degrees)');
    ylabel('Normalized Sum of Derivatives');
    title('2D Heatmap of Normalized Sum of Derivatives and Line Angles');
end

function [lineX, lineY] = bresenham(x1, y1, x2, y2)
    % BRESENHAM Generate pixel coordinates for a line using Bresenham's algorithm.
    %
    % Inputs:
    %   x1, y1 - Starting point
    %   x2, y2 - Ending point
    %
    % Outputs:
    %   lineX, lineY - Pixel coordinates of the line

    % Initialize variables
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    sx = sign(x2 - x1);
    sy = sign(y2 - y1);
    err = dx - dy;

    % Initialize output
    lineX = [];
    lineY = [];

    % Bresenham's algorithm loop
    while true
        lineX = [lineX; x1];
        lineY = [lineY; y1];
        if x1 == x2 && y1 == y2
            break;
        end
        e2 = 2 * err;
        if e2 > -dy
            err = err - dy;
            x1 = x1 + sx;
        end
        if e2 < dx
            err = err + dx;
            y1 = y1 + sy;
        end
    end
end
