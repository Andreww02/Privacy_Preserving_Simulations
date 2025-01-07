function [lines] = f_generateRandomLines(imgSize, numLines, lineLength)
    % F_GENERATERANDOMLINES Generate random straight lines in a scene.
    %
    % Inputs:
    %   imgSize    - Size of the image as [rows, cols]
    %   numLines   - Number of random lines to generate
    %   lineLength - Length of each line (in pixels)
    %
    % Outputs:
    %   lines - A structure array with fields:
    %           lines(i).start = [x1, y1] (starting point)
    %           lines(i).end   = [x2, y2] (ending point)
    %
    % Example:
    %   lines = f_generateRandomLines([512, 512], 10, 50);

    % Validate inputs
    arguments
        imgSize (1,2) double {mustBePositive, mustBeInteger}
        numLines (1,1) double {mustBePositive, mustBeInteger}
        lineLength (1,1) double {mustBePositive, mustBeInteger}
    end

    % Extract image dimensions
    rows = imgSize(1);
    cols = imgSize(2);

    % Initialize output
    lines(numLines) = struct('start', [], 'end', []);

    % Generate random lines
    for i = 1:numLines
        % Random starting point
        x1 = randi([1, cols]);
        y1 = randi([1, rows]);

        % Random direction (angle in radians)
        theta = rand() * 2 * pi;

        % Compute ending point based on the angle and line length
        x2 = round(x1 + lineLength * cos(theta));
        y2 = round(y1 + lineLength * sin(theta));

        % Ensure the line stays within image bounds
        x2 = min(max(x2, 1), cols);
        y2 = min(max(y2, 1), rows);

        % Store the line endpoints
        lines(i).start = [x1, y1];
        lines(i).end = [x2, y2];
    end
end
