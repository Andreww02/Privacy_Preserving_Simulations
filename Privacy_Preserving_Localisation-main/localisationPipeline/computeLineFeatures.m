function [sumDerivatives, angles] = computeLineFeatures(img, lines)
    numLines = length(lines);
    sumDerivatives = zeros(1, numLines);
    angles = zeros(1, numLines);

    % Get image size
    imgSize = size(img);

    for i = 1:numLines
        % Extract line start and end points
        startPt = lines(i).start;
        endPt = lines(i).end;

        % Get coordinates along the line
        [lineX, lineY] = bresenham(startPt(1), startPt(2), endPt(1), endPt(2));

        % Keep coordinates within image bounds
        lineX = min(max(lineX, 1), imgSize(2));
        lineY = min(max(lineY, 1), imgSize(1));

        % Extract pixel intensities along the line
        pixelValues = img(sub2ind(imgSize, lineY, lineX));

        % Compute first derivatives
        derivatives = diff(pixelValues);

        % Compute sum of the squares of derivatives
        sumDerivatives(i) = sum(derivatives.^2);

        % Compute dx and dy
        dx = endPt(1) - startPt(1);
        dy = endPt(2) - startPt(2);

        % Handle vertical lines (dx = 0)
        if dx == 0
            angle = 90; % Vertical line
        else
            % Compute gradient
            m = dy / dx;

            % Compute angle with respect to the horizontal axis
            angle = atand(abs(m)); 

            % Adjust angle for negative gradients to fit in [0, 180]
            if m < 0
                angle = 180 - angle;
            end
        end

        % Store angle
        angles(i) = angle;
    end

    sumDerivativesLog = log1p(sumDerivatives);
    sumDerivativesLogNorm = (sumDerivativesLog - min(sumDerivativesLog)) / (max(sumDerivativesLog) - min(sumDerivativesLog));
    sumDerivatives = sumDerivativesLogNorm;
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
