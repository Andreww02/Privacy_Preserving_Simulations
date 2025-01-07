clear;
clc;
close all;


mask = getMask(3);



% dataset = 'Digiteo_seq_2/Passive-Stereo/RGB-D/rgb/';
dataset = 'rgbd_dataset_freiburg2_pioneer_360/rgbd_dataset_freiburg2_pioneer_360/rgb/';
fname = '1311876800.398168.png';

img = imread(strcat('data/',dataset,fname));
img = double(im2gray(img));


mask.values = ([1 0 -1;
                                  2 0 -2;
                                  1 0 -1]);
horiz = conv2(img, mask.values, 'same');


mask.values = ([1 2 1;
                                  0 0 0;
                                  -1 -2 -1]);
vert = conv2(img, mask.values, 'same');

figure
subplot(1,2,1);
imagesc(horiz);
title('horiz')

subplot(1,2,2);
imagesc(vert);
title('vert')


figure
edges = sqrt(vert.^2 + horiz.^2);
imagesc(edges);
axis image

figure(10)
hold on
plot(max(edges,[],2));
title('slide over rows')

figure(11)
hold on
plot(max(edges,[],1));
title('slide over cols')

% now compare to other image
fname = '1311876801.867700.png';

img = imread(strcat('data/',dataset,fname));
img = double(im2gray(img));


mask.values = ([1 0 -1;
                                  2 0 -2;
                                  1 0 -1]);
horiz = conv2(img, mask.values, 'same');


mask.values = ([1 2 1;
                                  0 0 0;
                                  -1 -2 -1]);
vert = conv2(img, mask.values, 'same');

figure
edges = sqrt(vert.^2 + horiz.^2);
imagesc(edges);
axis image

figure(10)
hold on
plot(max(edges,[],2));

figure(11)
hold on
plot(max(edges,[],1));


%% run sequence

fnames = {"1311876800.499177",
                  "1311876800.550588",
                  "1311876800.584578",
                  "1311876800.626767",
                  "1311876800.669072"};

for imgIdx = 1:length(fnames)
    
    img = imread(strcat('data/',dataset,fnames{imgIdx},'.png'));
    img = double(im2gray(img));
    
    mask.values = ([1 0 -1;
                                      2 0 -2;
                                      1 0 -1]);
    horiz = conv2(img, mask.values, 'same');


    mask.values = ([1 2 1;
                                      0 0 0;
                                      -1 -2 -1]);
    vert = conv2(img, mask.values, 'same');
    edges = sqrt(vert.^2 + horiz.^2);
    
    figure(15)
    hold on
    plot(max(edges,[],2));

    figure(16)
    hold on
    plot(max(edges,[],1));
end

              
              
              