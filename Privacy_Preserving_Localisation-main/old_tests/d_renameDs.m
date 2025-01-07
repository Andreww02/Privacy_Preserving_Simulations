clear;
clc;


ds.name = 'IndoorLightingChanges';
ds.imagePath = 'data/third-floor-csc1_2019/cam0/data';    
ds.prefix='frame-';
ds.extension='.png';



files = dir(ds.imagePath);

for i = 3:length(files)
    movefile(strcat(ds.imagePath,'/',files(i).name), sprintf('%s/frame-%d.png',ds.imagePath,i-3))
end



