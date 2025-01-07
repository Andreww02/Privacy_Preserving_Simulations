% try masks over different regions

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
ds.convert2gray = true;

ds = loadImgs(ds);


mask.values = fspecial('log',11,1);


img = ds.imgs{12};


figure
imagesc(img)

figure
fullResConv = conv2(img,mask.values,'same');
imagesc(fullResConv);



regionSize = 20; % assume square

assert(mod(size(img,1),regionSize) == 0);
assert(mod(size(img,2),regionSize) == 0);

newNRows = size(img,1)/regionSize;
newNCols = size(img,2)/regionSize;

newImg = zeros(newNRows,newNCols);

for i = 1:newNRows
    for j = 1:newNCols
        conv = conv2(img(((i-1)*regionSize + 1):i*regionSize,...
                                       ((j-1)*regionSize + 1):j*regionSize),mask.values,'same');
        newImg(i,j) = max(conv,[],'all');
    end
end

figure
imagesc(newImg)



%% patch normalise

R_window = 8;

normImg = patchNormalise(img,R_window);

figure
imagesc(normImg)


for i = 1:newNRows
    for j = 1:newNCols
        conv = conv2(normImg(((i-1)*regionSize + 1):i*regionSize,...
                                       ((j-1)*regionSize + 1):j*regionSize),mask.values,'same');
        newImg(i,j) = max(conv,[],'all');
    end
end

figure
imagesc(newImg)
