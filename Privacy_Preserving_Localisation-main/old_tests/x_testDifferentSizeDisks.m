clear;
clc;
close all;



ds.name = 'chess_seq_01';
ds.imagePath = 'data/chess/seq-01/seq-01';    
ds.prefix='frame-';
ds.extension='.png';
ds.suffix='.color';
ds.imageSkip = 10;     % use every n-th image
ds.imageIndices = 1:ds.imageSkip:999;    
ds.isPadded = true;
ds.convert2gray = true;

ds = loadImgs(ds);

img = ds.imgs{1};


diskSizes = 4:1:30;
convImages = runDisks(img,diskSizes);

figure
imagesc(img)


% consider a pixel
pixels(1).k = 418;
pixels(1).l = 348;
pixels(1).info = 'dark chess square';


pixels(2).k = 422;
pixels(2).l = 309;
pixels(2).info = 'knight';

pixels(3).k = 63;
pixels(3).l = 333;
pixels(3).info = 'map';

pixels(4).k = 126;
pixels(4).l = 591;
pixels(4).info = 'tv corner';

pixels(5).k = 300;
pixels(5).l = 261;
pixels(5).info = 'chair hole';


hold on
for i = 1:length(pixels)
    plot(pixels(i).l,pixels(i).k,'ro','LineWidth',2);
end



% plot trace as function of disks
figure
hold on
for i = 1:length(pixels)
    plot(diskSizes, reshape(convImages(pixels(i).k,pixels(i).l,:),1,[]));
end

legend({pixels(:).info})
xlabel('Disk radius [px]')
ylabel('Convolution value')


% descriptor
lightBlobDescriptor = zeros(size(convImages,1),size(convImages,2));
for i = 1:size(convImages,1)
    for j = 1:size(convImages,2)
        pixelTrace = convImages(i,j,:);
        lightBlobDescriptor(i,j) = max(pixelTrace) - min(pixelTrace);
    end
end
figure
imagesc(lightBlobDescriptor);

% gradient descriptor
lightBlobGrads = zeros(size(convImages,1),size(convImages,2));
for i = 1:size(convImages,1)
    for j = 1:size(convImages,2)
        pixelTrace = reshape(convImages(i,j,:),1,[]);
        lightBlobGrads(i,j) = getGradOfLinearRegion(diskSizes,pixelTrace,10);
    end
end
figure
h = imagesc(lightBlobGrads);
% set(h, 'AlphaData', 1-isnan(lightBlobGrads))
title('light blob grads')

i=5;
% can findpeaks along axis


[pks,locs,w,p] = findPeaksInConv(convImages);

figure
imagesc(pks)
title('peak value')

figure
imagesc(locs)
title('disk scale')

figure
imagesc(w)
title('peak width')

figure
imagesc(p)
title('peak prominence')

% % can also useregional max in 3d
tmp = imregionalmax(convImages);
tmp2 = any(tmp,3); % flatten using logical OR

figure
imagesc(tmp2)

points = detectSIFTFeatures(img);

return
figure
hold on
plot(max(lightBlobGrads,[],1))
plot(min(lightBlobGrads,[],1))
title('Max/min by col')
figure
hold on
plot(max(lightBlobGrads,[],2))
plot(min(lightBlobGrads,[],2))
title('Max/min by row')



%% inverse disks for dark blobs

convImages = runDisks(img,diskSizes,true);

figure
imagesc(img)


% consider a pixel
pixels(1).k = 418;
pixels(1).l = 348;
pixels(1).info = 'dark chess square';


pixels(2).k = 422;
pixels(2).l = 309;
pixels(2).info = 'knight';

pixels(3).k = 63;
pixels(3).l = 333;
pixels(3).info = 'map';

pixels(4).k = 126;
pixels(4).l = 591;
pixels(4).info = 'tv corner';

hold on
for i = 1:length(pixels)
    plot(pixels(i).l,pixels(i).k,'ro','LineWidth',2);
end



% plot trace as function of disks
figure
hold on
for i = 1:length(pixels)
    plot(diskSizes, reshape(convImages(pixels(i).k,pixels(i).l,:),1,[]));
end

legend({pixels(:).info})
xlabel('Disk radius [px]')
ylabel('Convolution value')


% descriptor
darkBlobDescriptor = zeros(size(convImages,1),size(convImages,2));
for i = 1:size(convImages,1)
    for j = 1:size(convImages,2)
        pixelTrace = convImages(i,j,:);
        darkBlobDescriptor(i,j) = max(pixelTrace) - min(pixelTrace);
    end
end
figure
imagesc(darkBlobDescriptor);


% gradient descriptor
darkBlobGrads = zeros(size(convImages,1),size(convImages,2));
for i = 1:size(convImages,1)
    for j = 1:size(convImages,2)
        pixelTrace = reshape(convImages(i,j,:),1,[]);
        darkBlobGrads(i,j) = getGradOfLinearRegion(diskSizes,pixelTrace,10);
    end
end
figure
imagesc(darkBlobGrads);