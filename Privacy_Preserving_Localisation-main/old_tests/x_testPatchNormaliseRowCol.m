clear;
clc;
close all;


% ds.name = 'chess_seq_01';
% ds.imagePath = 'data/chess/seq-01/seq-01';    
% ds.prefix='frame-';
% ds.extension='.png';
% ds.suffix='.color';

ds.name = 'IndoorLightingChanges';
ds.imagePath = 'data/third-floor-csc1_2019/cam0/data';    
ds.prefix='frame-';
ds.extension='.png';
ds.suffix='';
ds.isPadded = false;


ds.imageSkip = 1;     % use every n-th image
% ds.imageIndices = 1:ds.imageSkip:900;    
ds.imageIndices = 370:ds.imageSkip:380;    
ds.convert2gray = true;

ds = loadImgs(ds);


img = ds.imgs{8};


figure
subplot(3,2,1)
imagesc(img)
axis image
colorbar
return

R_window = 8;

normImg = patchNormalise(img,R_window);

subplot(3,2,2)
imagesc(normImg)
axis image
colorbar



% mask.values = fspecial('log',11,3);
mask.values = fspecial('disk',2);
conv = conv2(img, mask.values, 'same');
subplot(3,2,3)
imagesc(conv)
axis image
colorbar


convNorm = conv2(normImg, mask.values, 'same');
subplot(3,2,4)
imagesc(convNorm)
axis image
colorbar


subplot(3,2,5)
title('rows')
hold on
plot(max(conv,[],2));
yyaxis right
plot(max(convNorm,[],2));

subplot(3,2,6)
title('cols')
hold on
plot(max(conv,[],1));
yyaxis right
plot(max(convNorm,[],1));


