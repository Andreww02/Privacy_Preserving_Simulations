clear;
clc;
close all;


mask = getMask(3);



% dataset = 'Digiteo_seq_2/Passive-Stereo/RGB-D/rgb/';
dataset = 'rgbd_dataset_freiburg2_pioneer_360/rgbd_dataset_freiburg2_pioneer_360/rgb/';
fname = '1311876800.398168.png';

img = imread(strcat('data/',dataset,fname));
img = double(im2gray(img));

% laplacian of gaussian
% mask.values = ([0 -1 0;
%                                   -1 4 -1;
%                                   0 -1 0]);
mask.values = fspecial('log',11,0.01);
conv = conv2(img, mask.values, 'same');

figure
imagesc(conv);
axis image





%% run sequence

fnames = {"1311876800.499177",
                  "1311876801.867700"};

for imgIdx = 1:length(fnames)
    
    img = imread(strcat('data/',dataset,fnames{imgIdx},'.png'));
    img = double(im2gray(img));
    
    mask.values = fspecial('log',11,1);
    
    convs = conv2(img, mask.values, 'same');
    
    figure(15)
    hold on
    plot(max(convs,[],2));

    figure(16)
    hold on
    plot(max(convs,[],1));
end


%% run disks of different sizes

radii = [1,2,3];

for radIdx = 1:length(radii)
    mask.values = fspecial('disk',radii(radIdx));
    convs = conv2(img, mask.values, 'same');
    
    figure(20)
    hold on
    plot(max(convs,[],2));

    figure(21)
    hold on
    plot(max(convs,[],1));
    
    
    figure(22)
    subplot(1,length(radii),radIdx)
    imagesc(convs);
    axis image
end
figure(21)
legend('1','2','3');
              
              