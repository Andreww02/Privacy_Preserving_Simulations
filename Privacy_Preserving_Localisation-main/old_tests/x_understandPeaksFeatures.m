% syntehtic image generation to understand blob detection with peak finder

clear;
clc;
close all;


img = zeros(35);

dotRadius = 4;
% dot = fspecial('disk',dotRadius);
dot = fspecial('gaussian',2*dotRadius+1,2);

dotCenter = [25,15];

topLeft = dotCenter - dotRadius;
bottomRight = dotCenter + dotRadius;

img(topLeft(2):bottomRight(2),topLeft(1):bottomRight(1)) = dot;

% img(dotCenter(2),dotCenter(1)) = 0;

img = 256*img./(sum(img,'all'));

figure
imagesc(img)


% run different size disks
diskSizes = 2:1:10;
convImages = runDisks(img,diskSizes);


pixels(1).k = dotCenter(2);
pixels(1).l = dotCenter(1);
pixels(1).info = 'center';

pixels(2).k = dotCenter(2)+round(dotRadius/2);
pixels(2).l = dotCenter(1)+round(dotRadius/2);
pixels(2).info = 'halfway';

pixels(3).k = dotCenter(2)+dotRadius;
pixels(3).l = dotCenter(1)+dotRadius;
pixels(3).info = 'outside edge';

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




% feature descriptor
[pks,locs,w,p] = findPeaksInConv(convImages,0.5);


vals = {pks,locs,w,p};
titles = {'Peak value', 'Disk Scale Index', 'Peak width', 'Peak Prominence'};


figure
for i = 1:4
    subplot(2,2,i)
    imagesc(vals{i})
    title(titles{i})
    axis image
    colorbar
    
    % draw dots
    hold on
    for i = 1:length(pixels)
        plot(pixels(i).l,pixels(i).k,'ro','LineWidth',2);
    end
end

