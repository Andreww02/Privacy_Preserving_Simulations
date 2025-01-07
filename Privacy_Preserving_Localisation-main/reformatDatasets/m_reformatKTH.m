clear
clc



files = dir('../data/dum_cloudy1/png/');
% files = dir('../data/min_cloudy1/png/');
% files = dir('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');
files = natsortfiles(files);

j = 1;

for id = 1:length(files)
    % Get the file name 
    [~, f,ext] = fileparts(files(id).name);
    if all(ext == '.png')
        rename = sprintf('%05d%s', j, ext); 
        movefile([files(id).folder, '\', files(id).name], [files(id).folder, '\', rename]);
        j = j+1;
    end
end