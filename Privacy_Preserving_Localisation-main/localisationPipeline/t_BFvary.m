% test script to check that brightness is actually varying
clear;
clc;
close all;


dset = getDset('../data/MyDsets/PNRtopWalkthrough1/imgs');


imgIdx = [1,800,1500,2300];


BFvals = linspace(0.7,1.3,3);


for row = 1:length(imgIdx)
    for col = 1:length(BFvals)
        imds = ATimds(dset.path, BFvals(col));
        imgStack{row,col} = readimage(imds, imgIdx(row));
    end
end

tmp = zeros(1,1,2);
tmp(1,1,2) = 255;

ATimgrid(imgStack, [length(imgIdx),length(BFvals)], 'imBounds', tmp, 'yDirs', "reverse",'colormaps',"gray",'showAxes', false...
               ,'xlabels',["BF = 0.7","BF = 1.0","BF = 1.3"]);



