clear;
clc;
close all;

vidPath = '../data/MyDsets/Videos/';
vidName = 'PNRroomSimpsons';
vidFormat = '.mp4';

targetPath = '../data/MyDsets/';

mkdir(strcat(targetPath,vidName));

vid = VideoReader(strcat(vidPath,vidName,vidFormat));

ii=1;
while hasFrame(vid)
   img = readFrame(vid);
   filename = [sprintf('%05d',ii) '.png'];
   fullname = fullfile(strcat(targetPath,vidName),filename);
   imwrite(img,fullname)    
   ii = ii+1;
end




