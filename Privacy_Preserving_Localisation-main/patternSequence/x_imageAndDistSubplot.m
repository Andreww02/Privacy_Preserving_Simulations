clear;
clc;
close all

dset = getDset('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');

imageSet = imageDatastore(dset.path,'LabelSource','foldernames','IncludeSubfolders',true);

img2Show = [1,200,500,700, 900];
nImgs = length(img2Show);

vertSpace = 0.02;
horizSpace = 0.02;


nLines = 2e3;
nCircles = nLines;
radii = [15,50];


[x1,x2] = meshgrid(0:255, 0:255);
x1 = x1(:);
x2 = x2(:);
xi = [x1 x2];


figure
imStack = {};
for i = 1:nImgs
    imStack{i} = readimage(imageSet, img2Show(i));

    [features, ~] = maxMinFeaturesAlongUniqueRandLines(imStack{i}, nLines, 100);
    [f,xi] = ksdensity(features,xi);
    imStack{i + nImgs} = reshape(f,[256,256]);

    [xToSample, yToSample] = generateCircleSamplesPts(dset.imsize, nCircles, radii, 200);
    [features, ~] = maxMinFeaturesAlongCurves(imStack{i}, xToSample,yToSample);
    [f,xi] = ksdensity(features,xi);
    imStack{i + 2*nImgs} = reshape(f,[256,256]);
end

showAxes = [zeros(1,nImgs);
                      ones(2,nImgs)];

cmap = ["gray"; "default"; "default"];
yDirs = ["reverse"; "normal"; "normal"];
xlabel = "max";
ylabel = "min";

ATimgrid(imStack, [3,nImgs],'showAxes',showAxes,'colormaps',cmap,'xlabels',xlabel,'ylabels',ylabel,'yDirs',yDirs);

return 

figure 
for i = 1:nImgs
    img = readimage(imageSet, img2Show(i));

    % features to be used
    [features, metrics] = maxMinFeaturesAlongUniqueRandLines(img, nLines, 100);
    
    ax(1) = subaxis(3, nImgs, i,'sv',vertSpace,'sh',horizSpace);
    imagesc(img)
    axis image
    axis off
    colormap(ax(1),'gray')

    ax(2) = subaxis(3, nImgs, i+nImgs,'sv',vertSpace,'sh',horizSpace);
    colormap(ax(2),'parula')
    [f,xi] = ksdensity(features,xi);
    imagesc(0:255,0:255,reshape(f,[256,256]))
    axis image
    set(gca,'YDir','normal')


    [xToSample, yToSample] = generateCircleSamplesPts(dset.imsize, nCircles, radii, 200);
    [features, metrics] = maxMinFeaturesAlongCurves(img, xToSample,yToSample);

    ax(3) = subaxis(3, nImgs, i+2*nImgs,'sv',vertSpace,'sh',horizSpace);
    colormap(ax(2),'parula')
    [f,xi] = ksdensity(features,xi);
    imagesc(0:255,0:255,reshape(f,[256,256]))
    axis image
    set(gca,'YDir','normal')

end


