% split a folder of imgs where there are multiple trajectories

clear
clc
close all


raw.pth = fullfile('../data/MyDsets/ABS_raw/');
dest.pth = fullfile('../data/MyDsets/ABS');

if ~exist(dest.pth, 'dir')
    mkdir(dest.pth)
end

traj_names = ["norm", "rot", "trans", "rot_trans"];

for i = 1:length(traj_names)
    dest.paths(i) = fullfile(dest.pth, traj_names(i),'imgs');
    if ~exist(dest.paths(i), 'dir')
        mkdir(dest.paths(i))
    end
end

files = dir(raw.pth);
files = files(3:end);
files = natsortfiles(files);

img_idx = 0;

for file_idx = 1:length(files)
    traj_idx = mod(file_idx-1, length(traj_names))+1;
    if traj_idx == length(traj_names)
        img_idx = img_idx + 1;
    end
    
    img = imread(fullfile(files(file_idx).folder, files(file_idx).name));
    img = im2gray(img);

    imwrite(img, fullfile(dest.paths(traj_idx), sprintf('%05d.png',img_idx)))
end


dset.imsize = size(img);
dset.nImgs = length(files)/length(traj_names);
dset.frameRate = 10;
for i = 1:length(traj_names)
    dset.path = dest.paths(i);
    dset
    save(fullfile(dest.paths(i), '../dsetInfo.mat'))
end




