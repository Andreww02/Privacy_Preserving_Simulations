function [angles, sumDerivativesLogNorm, angleEdges, featureEdges, counts] = f_generateHist(img, numLines, lineLength, numBinsFeature, numBinsAngle)
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
        % disp(pixelValues);

        % Compute first derivatives
        derivatives = diff(pixelValues);
        % disp("derivatives:");
        % disp(derivatives);

        % Compute sum of the squares of derivatives
        sumDerivatives(i) = sum(derivatives.^2);
        % disp("sum:");
        % disp(sumDerivatives);

        
        % Compute dx and dy
        dx = endPt(1) - startPt(1);
        dy = endPt(2) - startPt(2);
        
        % Handle vertical lines (dx = 0)
        if dx == 0
            angle = 90; % Vertical line
        else
            % Compute gradient
            m = dy / dx;
            % fprintf('dy: %.2f\n', dy);
            % fprintf('dx: %.2f\n', dx);
            % fprintf('m: %.2f\n', m);
        
            % Compute angle with respect to the horizontal axis based on the gradient
            angle = atand(abs(m)); % Angle with respect to x-axis
            % fprintf('angle: %.2f\n', angle);
            % Adjust angle for negative gradients
            if m < 0
                angle = 180 - angle; % Reflect to 90-180 degrees
                % fprintf('negative gradient angle: %.2f\n', angle);
            end
        end
        
        % Store angle
        angles(i) = angle;
        % plot([startPt(1), endPt(1)], [startPt(2), endPt(2)], 'r-', 'LineWidth', 1);
        % disp("angles:");
        % disp(angles);
    end

    % Normalize the sum of derivatives to range [0, 1]
    % sumDerivatives = (sumDerivatives - min(sumDerivatives)) / (max(sumDerivatives) - min(sumDerivatives));
    % sumDerivatives = sumDerivatives - min(sumDerivatives);
    % sumDerivatives = sumDerivatives / max(sumDerivatives);
    % disp("sumDerivatives:");
    % disp(sumDerivatives);

    sumDerivativesLog = log1p(sumDerivatives); % Logarithmic scaling with base of e
    % sumDerivativesLog = log10(sumDerivatives + eps); % Logarithmic scaling with base of 10

    % disp("sumDerivatives after log:");
    % disp(sumDerivatives);

    sumDerivativesLogNorm = (sumDerivativesLog - min(sumDerivativesLog)) / (max(sumDerivativesLog) - min(sumDerivativesLog));
    % sumDerivativesLogNorm = sumDerivativesLog;

    % fprintf('sumDerivatives: %.2f\n', sumDerivatives);
    

    % Normalize angles to range [0, 360]
    % angles = mod(angles, 180);

    % Create bin edges for features and angles
    featureEdges = linspace(0, max(sumDerivativesLogNorm), numBinsFeature + 1);
    angleEdges = linspace(0, max(angles), numBinsAngle + 1);

    % disp(angleEdges);
    % disp(featureEdges);

    % Create a 2D histogram
    counts = histcounts2(sumDerivativesLogNorm, angles, featureEdges, angleEdges);

    %% Plot the 2D heatmap
    figure;
    imagesc(featureEdges(1:end-1), angleEdges(1:end-1), counts');
    set(gca, 'YDir', 'normal');
    colorbar;
    clim([0, 7]);
    ylabel('Line Angle (degrees)');
    xlabel('Normalized Sum of Derivatives');
    title('2D Heatmap of Normalised Sum of Squared Derivatives and Line Angles');

    sigma = 1; % Standard deviation for Gaussian kernel
    kernel = fspecial('gaussian', [3 3], sigma);
    counts = imfilter(counts, kernel, 'same');

    % Plot the 2D heatmap
    figure;
    imagesc(featureEdges(1:end-1), angleEdges(1:end-1), counts');
    set(gca, 'Visible', 'off');
    % colorbar;
    clim([0, 6]);
    % ylabel('Line Angle (degrees)');
    % xlabel('Normalized Sum of Derivatives');
    % title('2D Heatmap of Normalised Sum of Derivatives and Line Angles');
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
