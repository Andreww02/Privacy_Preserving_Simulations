clear;
clc;


files = dir('../data/dum_cloudy1/png/');


for id = 1:length(files)
    % Get the file name 
    [~, f,ext] = fileparts(files(id).name);
    if all(ext == '.png')
        img = imread([files(id).folder, '\', files(id).name]);
        img = im2gray(img);
        imwrite(img, [files(id).folder, '\', files(id).name]);
    end
end