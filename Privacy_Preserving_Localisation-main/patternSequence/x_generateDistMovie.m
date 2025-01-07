clear;
clc;
close all;
wbars = findall(0,'type','figure','tag','TMWWaitbar');
delete(wbars);

VidTime = 30; %s

% dset = getDset('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb');
dset(1) = getDset('../data/MyDsets/PNRroomSimpsons/imgs');
dset(2) = getDset('../data/MyDsets/PNRroomSimpsonsRotated/imgs');
nDset = 2;

imset{1} = imageDatastore(dset(1).path,'LabelSource','foldernames','IncludeSubfolders',true);
imset{2} = imageDatastore(dset(2).path,'LabelSource','foldernames','IncludeSubfolders',true);

skip  = 10;
% skip  = 200;
nLines = 2e3;
nCircles = nLines;
radii = [15,50];

[x1,x2] = meshgrid(0:255, 0:255);
x1 = x1(:);
x2 = x2(:);
xi = [x1 x2];

imgIdxs = 1:skip:length(imset{1}.Files);

cmap = ["gray"; "default"; "default"; "default"];
yDirs = ["reverse"; "normal"; "normal"; "normal"];
xlabel = "max";
% ylabel = "min";
ylabel = ["";"min, Lines"; "min, Circles"; "min,Circles and Lines"];
showAxes = repmat([0;1;1;1], [1,2]);

figure(1)
set(gcf,'Position',[488.0000   47.4000  540.2000  714.6000]);
axisParams = {'FontSize',8};


imgStack = zeros(dset(1).imsize(1), dset(1).imsize(2), length(imgIdxs), nDset);
lineFeatureStack = zeros(256, 256, length(imgIdxs), nDset);
circFeatureStack = zeros(256, 256, length(imgIdxs), nDset);
circLineFeatureStack = zeros(256, 256, length(imgIdxs), nDset);

wbar = waitbar(0,'Loading...');

% data extraction loop:
for i = 1:length(imgIdxs)
    waitbar((i-1)/length(imgIdxs), wbar, sprintf("%.2f%% done",100*(i-1)/length(imgIdxs)));
    for colIdx = 1:nDset
        imgStack(:,:,i,colIdx) = readimage(imset{colIdx}, imgIdxs(i));
    
        [features, ~] = maxMinFeaturesAlongUniqueRandLines(imgStack(:,:,i,colIdx), nLines, 100);
        [f,xi] = ksdensity(features,xi);
        lineFeatureStack(:,:,i,colIdx) = reshape(f,[256,256]);
    
        [xToSample, yToSample] = generateCircleSamplesPts(dset(1).imsize, nCircles, radii, 200);
        [features, ~] = maxMinFeaturesAlongCurves(imgStack(:,:,i,colIdx), xToSample,yToSample);
        [f,xi] = ksdensity(features,xi);
        circFeatureStack(:,:,i,colIdx) = reshape(f,[256,256]);


        [features, metrics] = maxMinFeaturesUniCircLines(imgStack(:,:,i,colIdx), nCircles, 0.5, radii, 200);
        [f,xi] = ksdensity(features,xi);
        circLineFeatureStack(:,:,i,colIdx) = reshape(f,[256,256]);

    end
end

save('fingerprintsInDset.mat','lineFeatureStack','circFeatureStack', 'circLineFeatureStack', 'imgIdxs')

%% generate vid
% plotting loop:
lineMax = max(lineFeatureStack,[],'all');
circMax = max(circFeatureStack,[],'all');
circLineMax = max(circLineFeatureStack,[],'all');

fparam = getATfontParams();


for i = 1:length(imgIdxs)
    figure(1)  
    
    for colIdx = 1:nDset
        imPltStack{colIdx} = imgStack(:,:,i,colIdx);
        imPltStack{nDset + colIdx} = lineFeatureStack(:,:,i,colIdx)/lineMax;
        imPltStack{2*nDset + colIdx} = circFeatureStack(:,:,i,colIdx)/circMax;
        imPltStack{3*nDset + colIdx} = circLineFeatureStack(:,:,i,colIdx)/circLineMax;
    end
    clf
    ATimgrid(imPltStack, [4, nDset],'showAxes',showAxes,'colormaps',cmap,...
                   'xlabels',xlabel,'ylabels',ylabel,'yDirs',yDirs,'axisParams',axisParams);
    annotation('textbox', [0.10, 0.95, 0, 0], 'string', sprintf("%d/%d", imgIdxs(i), length(imset{1}.Files)), 'HorizontalAlignment','center',...
                      'VerticalAlignment','middle', fparam{:})
    F(i) = getframe(gcf);
    drawnow
end


% create the video writer with 
writerObj = VideoWriter('roomRotVsNormal.mp4','MPEG-4');
writerObj.FrameRate = round(length(F)/VidTime);
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i);    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);