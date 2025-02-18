function [angles, sumDerivativesLogNorm, angleEdges, featureEdges, smoothCounts] = ...
         f_generateHistogramSmooth(ax, img, numLines, lineLength, numBinsFeature, numBinsAngle)
% f_generateHistogramSmooth
%   Computes a 2D histogram (heatmap) of the normalized sum of squared
%   derivatives (features) versus the line angles sampled from the image,
%   and applies temporal smoothing using exponential filtering.
%
%   Inputs:
%     ax             - Axes handle on which to plot the heatmap.
%     img            - Input grayscale image.
%     numLines       - Number of random lines to sample.
%     lineLength     - Length of each random line.
%     numBinsFeature - Number of bins for the feature (sum of derivatives).
%     numBinsAngle   - Number of bins for the line angle.
%
%   Outputs:
%     angles, sumDerivativesLogNorm, angleEdges, featureEdges, smoothCounts

    % Validate that the image is grayscale.
    if size(img, 3) ~= 1
        error('Input image must be grayscale.');
    end

    imgSize = size(img);
    % Generate random lines within the image.
    lines = f_generateRandomLines(imgSize, numLines, lineLength);

    % Initialize arrays to store feature values and angles.
    sumDerivatives = zeros(1, numLines);
    angles         = zeros(1, numLines);

    for i = 1:numLines
        % Extract the endpoints of the current line.
        startPt = lines(i).start;
        endPt   = lines(i).end;

        % Get the pixel coordinates along the line using Bresenham's algorithm.
        [lineX, lineY] = bresenham(startPt(1), startPt(2), endPt(1), endPt(2));
        % Clamp coordinates to the image boundaries.
        lineX = min(max(lineX, 1), imgSize(2));
        lineY = min(max(lineY, 1), imgSize(1));

        % Get pixel intensities along the line.
        pixelValues = img(sub2ind(imgSize, lineY, lineX));

        % Compute the first derivative along the line and sum the squared values.
        derivatives       = diff(pixelValues);
        sumDerivatives(i) = sum(derivatives.^2);

        % Compute the line's angle.
        dx = endPt(1) - startPt(1);
        dy = endPt(2) - startPt(2);
        if dx == 0
            angle = 90; % vertical line
        else
            m     = dy / dx;
            angle = atand(abs(m));
            if m < 0
                angle = 180 - angle;
            end
        end
        angles(i) = angle;
    end

    % Apply logarithmic scaling and normalize the feature values to [0,1].
    % Introduce a scaling factor to expand the dynamic range.
    alpha = 1;  % Experiment with this value. Increasing alpha will "stretch" the range more.
    
    % Scale the derivative values before applying the logarithm.
    scaledDerivatives = alpha * sumDerivatives;
    
    % Use a logarithmic transformation.
    sumDerivativesLog = log1p(scaledDerivatives);
    
    % Normalize the log-transformed values to [0,1].
    normValues = (sumDerivativesLog - min(sumDerivativesLog)) / (max(sumDerivativesLog) - min(sumDerivativesLog));
    sumDerivativesLogNorm = normValues;

    % Create bin edges for the histogram.
    featureEdges = linspace(0, max(sumDerivativesLogNorm), numBinsFeature + 1);
    angleEdges   = linspace(0, max(angles), numBinsAngle + 1);

    % Compute the 2D histogram.
    counts = histcounts2(sumDerivativesLogNorm, angles, featureEdges, angleEdges);

    % Spatial smoothing: Apply gamma correction and a Gaussian filter.
    sigma = 3; % Standard deviation for Gaussian kernel
    kernel = fspecial('gaussian', [55 55], sigma);
    gammaVal = 0.5;  % Gamma correction value.
    counts = counts.^ gammaVal;    
    counts = imfilter(counts, kernel, 'same');
    
    % Temporal smoothing: combine the new histogram with the previous one.
    persistent prevSmooth;
    temporalCoeff = 0.7;  % Adjust this coefficient (0 to 1) for smoother update.
    if isempty(prevSmooth) || ~isequal(size(prevSmooth), size(counts))
        prevSmooth = counts;
    end
    smoothCounts = temporalCoeff * prevSmooth + (1 - temporalCoeff) * counts;
    prevSmooth = smoothCounts;  % Store for the next frame.
    
    % Plot the temporally smoothed 2D heatmap.
    axes(ax);  % Set the current axes to ax.
    imagesc(featureEdges(1:end-1), angleEdges(1:end-1), smoothCounts');
    set(ax, 'YDir', 'normal');
    xlabel(ax, 'Normalized Sum of Derivatives');
    ylabel(ax, 'Line Angle (degrees)');
    title(ax, '2D Heatmap');
    fixedCLim = [0 1];  % Change these values as desired.
    caxis(ax, fixedCLim);
    % colorbar(ax);
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