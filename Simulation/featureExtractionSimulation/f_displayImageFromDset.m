function [img] = f_displayImageFromDset(dset, index)
    % DISPLAYIMAGEFROMDSET Display an image from the dataset by index
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

    % Display the image
    figure;
    imshow(img);
    title(sprintf('Image at Index %d', index));
end
