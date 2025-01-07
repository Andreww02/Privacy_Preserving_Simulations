clear;
clc;
close all;

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


dTheta = 6;
edgeAngles = -180:dTheta:(180-dTheta);
hsize = 3;

convImages = runEdges(img,edgeAngles,hsize);


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

pixels(5).k = 456;
pixels(5).l = 326;
pixels(5).info = 'table edge';

pixels(6).k = 322;
pixels(6).l = 252;
pixels(6).info = 'chair edge';

hold on
for i = 1:length(pixels)
    plot(pixels(i).l,pixels(i).k,'ro','LineWidth',2);
end



% plot trace as function of disks
figure
hold on
for i = 1:length(pixels)
    plot(edgeAngles, reshape(convImages(pixels(i).k,pixels(i).l,:),1,[]));
end

legend({pixels(:).info})
xlabel('Edge angle [deg]')
ylabel('Convolution value')


%% look for the largest percentage difference

edgeMeasure = zeros(size(convImages,1),size(convImages,2));
for i = 1:size(convImages,1)
    for j = 1:size(convImages,2)
        trace = convImages(i,j,:);
        edgeMeasure(i,j) = (max(trace) - min(trace))/mean(trace);
    end
end

figure
imagesc(edgeMeasure)
colorbar

% try to get direction of edge too
edgeDirection = zeros(size(convImages,1),size(convImages,2));
for i = 1:size(convImages,1)
    for j = 1:size(convImages,2)
        trace = reshape(convImages(i,j,:),1,[]);
        [~,loc] = max(trace);
        edgeDirection(i,j) = edgeAngles(loc);
    end
end

figure
colormap(getCmap())
imagesc(edgeDirection)
title('edge direction')
colorbar



