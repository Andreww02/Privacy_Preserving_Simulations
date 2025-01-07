clear;
clc;
close all;



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

img1 = ds.imgs{1};
img2 = ds.imgs{8};

figure
subplot(3,2,1)
imagesc(img1)
axis image
colorbar

subplot(3,2,2)
imagesc(img2)
axis image
colorbar


R_window = 10;


normImg1 = patchNormalise(img1,R_window);
normImg2 = patchNormalise(img2,R_window);


cMin = min([normImg1(:);normImg2(:)]);
cMax = max([normImg1(:);normImg2(:)]);

subplot(3,2,3)
imagesc(normImg1,[cMin,cMax])
axis image
colorbar

subplot(3,2,4)
imagesc(normImg2,[cMin,cMax])
axis image
colorbar


mask.values = fspecial('average',7);
% mask.values = fspecial('log',7,1);

convNormImg1 = conv2(normImg1, mask.values, 'same');
convNormImg2 = conv2(normImg2, mask.values, 'same');

% convNormImg1 = getSobelEdgeMag(conv2(normImg1, mask.values, 'same'));
% convNormImg2 = getSobelEdgeMag(conv2(normImg2, mask.values, 'same'));


subplot(3,2,5)
imagesc(convNormImg1)
axis image
colorbar
subplot(3,2,6)
imagesc(convNormImg2)
axis image
colorbar

