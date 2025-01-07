clear;
clc;
close all;



ds.name = 'chess_seq_01';
ds.imagePath = 'data/chess/seq-01/seq-01';    
ds.prefix='frame-';
ds.extension='.png';
ds.suffix='.color';
ds.imageSkip = 10;     % use every n-th image
ds.imageIndices = 1:ds.imageSkip:900;    
ds.isPadded = true;
ds.convert2gray = true;

ds = loadImgs(ds);

img = ds.imgs{1};


edgeStrengths = logspace(0,2,10);
opt.isVertical = true;
opt.hsize = 5;

convs = zeros(size(img,1),size(img,2),length(edgeStrengths));
for i = 1:length(edgeStrengths)
    opt.edgeStrength = edgeStrengths(i);
    mask = getValidHardwareMask("edge",opt);
    convs(:,:,i) = conv2(img,mask,'same');
end


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

pixels(4).k = 457;
pixels(4).l = 345;
pixels(4).info = 'table edge';

hold on
for i = 1:length(pixels)
    plot(pixels(i).l,pixels(i).k,'ro','LineWidth',2);
end



% plot trace as function of disks
figure
hold on
for i = 1:length(pixels)
    plot(edgeStrengths, reshape(convs(pixels(i).k,pixels(i).l,:),1,[]));
end

set(gca,'XScale','log')
legend({pixels(:).info})
xlabel('Edge strength [px]')
ylabel('Convolution value')
title('vertical edges')


%% horizontal

opt.isVertical = false;
convs = zeros(size(img,1),size(img,2),length(edgeStrengths));
for i = 1:length(edgeStrengths)
    opt.edgeStrength = edgeStrengths(i);
    mask = getValidHardwareMask("edge",opt);
    convs(:,:,i) = conv2(img,mask,'same');
end

% plot trace as function of disks
figure
hold on
for i = 1:length(pixels)
    plot(edgeStrengths, reshape(convs(pixels(i).k,pixels(i).l,:),1,[]));
end

set(gca,'XScale','log')
legend({pixels(:).info})
xlabel('Edge strength [px]')
ylabel('Convolution value')
title('horizontal edges')
