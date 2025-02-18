% function [img] = f_displayImageFromDset(dset, index)
%     % DISPLAYIMAGEFROMDSET Display an image from the dataset by index
%     %
%     % Inputs:
%     %   dset  - Struct containing the dataset (must include imageSet field)
%     %   index - Index of the image to display
%     %
%     %   displayImageFromDset(dset, 1);
% 
%     % Validate inputs
%     arguments
%         dset struct
%         index (1,1) double {mustBePositive, mustBeInteger} = 1
%     end
% 
%     % Check if index is within range
%     if index > dset.nImgs
%         error('Index exceeds the number of images in the dataset (%d).', dset.nImgs);
%     end
% 
%     % Read the image from the imageSet
%     img = readimage(dset.imageSet, index);
%     % img = imrotate(img, 08);
% 
%     % % Display the image
%     figure;
%     imshow(img);
%     % title(sprintf('Image at Index %d', index));
% end


function [img] = f_displayImageFromDset(dset, index)
    % DISPLAYIMAGEFROMDSET Display an image from the dataset by index
    % and draw 5 random lines of length 150 at different angles with random colors.
    %
    % Inputs:
    %   dset  - Struct containing the dataset (must include imageSet field)
    %   index - Index of the image to display
    %
    %   displayImageFromDset(dset, 1);

    % Validate inputs
    arguments
        dset struct
        index (1,1) double {mustBePositive, mustBeInteger} = 1
    end

    % Check if index is within range
    if index > dset.nImgs
        error('Index exceeds the number of images in the dataset (%d).', dset.nImgs);
    end

    % Read the image from the imageSet
    img = readimage(dset.imageSet, index);

    % Draw 5 random lines of length 150 at different angles with random colors
    figure;
    imshow(img);
    hold on;

    % Number of lines to draw
    numLines = 5;

    % Image dimensions
    [rows, cols, ~] = size(img);

    for i = 1:numLines
        % Random starting point (within the image bounds)
        x1 = randi([1, cols]);
        y1 = randi([1, rows]);

        % Random angle between 0 and 2*pi
        angle = rand * 2 * pi;

        % Length of the line
        length = 350;

        % Calculate endpoint of the line based on random angle
        x2 = round(x1 + length * cos(angle));
        y2 = round(y1 + length * sin(angle));

        % Ensure the line stays within image bounds
        x2 = min(max(x2, 1), cols);
        y2 = min(max(y2, 1), rows);

        % Generate a random color for each line
        lineColor = rand(1, 3); % RGB values between 0 and 1

        % Draw the line on the image with the random color
        plot([x1, x2], [y1, y2], 'Color', lineColor, 'LineWidth', 2);
    end

    hold off;
end
