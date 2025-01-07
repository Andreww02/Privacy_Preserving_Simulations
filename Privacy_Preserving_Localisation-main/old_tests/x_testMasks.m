clear;
clc;
close all;


mask = getMask(3);

mask.values = ([1 0 -1;
                                  2 0 -2;
                                  1 0 -1]);


dataset = 'Digiteo_seq_2';
fname = 'frame0.png';

img = imread(strcat('data/',dataset,'/Passive-Stereo/RGB-D/rgb/',fname));
img = double(img);

imshow(img);

slideRow = true;
[vec, newImg] = slideMask1D(img,mask,slideRow);
figure
plot(vec);

figure
subplot(1,2,1);
imagesc(newImg)
title('mine')

subplot(1,2,2);
convImg = conv2(img, mask.values, 'same');
imagesc(convImg);
title('conv2')


figure
smallConvImg = convImg(2:end-1,2:end-1);
hold on
plot(max(abs(smallConvImg)));
plot(max(abs(newImg)));



mean(newImg(:))
mean(smallConvImg(:))
