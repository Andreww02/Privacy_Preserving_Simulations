function [dset] = getDset(path, NameValueArgs)
%GETDSET: Load a dataset of images from a given path

% Input Arguments:
%   path --> a string that describes the path to the dataset location
%   (Optional) NameValueArgs --> to adjust the brightness scale

% Output:
%   a dset structure that contains:
%       imageSet: The imageDatastore object holding the dataset.
%       path: The directory path of the dataset.
%       brightnessFact: The brightness adjustment factor (default is 1).
%       name: A generated name for the dataset, based on its path.
%       imsize: The dimensions of the first image in the dataset (e.g., [height, width, channels]).
%       nImgs: The total number of images in the dataset.

    arguments
        path (1,1) string {mustBeFolder}  % Ensures path is a valid folder
        NameValueArgs.brightnessFact (1,1) double {mustBePositive} = 1; 
    end
    
    disp('Getting image dataset');

    % Create an image datastore
    dset.imageSet = imageDatastore(path,'LabelSource','foldernames','IncludeSubfolders',true);
    
    % Store the dataset's path and initialises brightness factor to '1'
    dset.path = path;
    dset.brightnessFact = 1;

    % Searches for the keyword "data" in the path.
    % Extracts the portion of the path following "data" to use as the dataset name.
    % Replaces backslashes (\) with underscores (_) to make it a valid identifier.
    % remove everything after data and call that the name of the dset
    tmp = path(strfind(dset.path,'data') + length('data') + 1:end);
    dset.name = strrep(fullfile(tmp),'\','_');
    
    % Read the first image in the dataset to determine its dimensions
    img = readimage(dset.imageSet,1);
    dset.imsize = size(img);

    % Counts the total number of  images in the dataset
    dset.nImgs = size(dset.imageSet.Files,1);

    
end