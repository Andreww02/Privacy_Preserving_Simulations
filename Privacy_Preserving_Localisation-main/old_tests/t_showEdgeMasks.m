clear;
clc;
close all;


figure
hsize = 10;
angles = linspace(-180,180,9);
angles = angles(1:8);

for i = 1:length(angles)
    mask = getEdgeMask(hsize,angles(i));
%     mask = getEdgeMaskIntegrate(hsize,angles(i));
    subplot(2,4,i);
    imagesc(mask);
    title(angles(i));
end