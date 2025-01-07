% overlay on the image which pixels were used in the hash

clear
clc
close all

% img = imread(fullfile('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb/00036.png'));
img = imread(fullfile('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb/00768.png'));
img = double(img);

% use_lines = 1;
% use_circ = 0;

use_lines = 0;
use_circ = 1;

n_features = 1000;

rng(3)
if use_lines
    lines = generateRandomLines(size(img), n_features);
elseif use_circ
    [xToSample, yToSample] = generateCircleSamplesPts(size(img), n_features, [15,50], 100);
end


figure(1)
colormap gray
imagesc(img)
axis image

if use_lines
    n_features = 100;
    t = zeros(length(lines), n_features);
    y = zeros(length(lines), n_features);
    for i = 1:length(lines)
        hold on
        [ta,ya] = drawTrace(img, lines(i), false);
        t(i,:) = ta;
        y(i,:) = ya;
    end

    figure(1)
    for i = 1:length(lines)
        hold on 
        [~,minPos] = min(y(i,:));
        [~,maxPos] = max(y(i,:));
        % draw min and max on picture
        tmin = t(i, minPos);
        coord = lines(i).point + tmin*lines(i).dir;
        plot(coord(1), coord(2),'mx');
    
        tmin = t(i, maxPos);
        coord = lines(i).point + tmin*lines(i).dir;
        plot(coord(1), coord(2),'bx');
    end
elseif use_circ
    interpVals = interp2(img,xToSample,yToSample);
    [~,bmax] = max(interpVals,[],2);
    [~,bmin] = min(interpVals,[],2);
    
    hold on
    for circI = 1:size(xToSample,1)
        plot(xToSample(circI,bmax(circI)), yToSample(circI,bmax(circI)),'bx')
        plot(xToSample(circI,bmin(circI)), yToSample(circI,bmin(circI)),'mx')
    end
end
axis off

%% saving
savePath = fullfile('../results/location_and_distribution_of_info');

if use_circ
    name = 'circ';
elseif use_lines
    name = 'line';
end

save2pdf(gcf, fullfile(savePath, sprintf("%s_location_of_features.pdf", name)))
saveas(gcf, fullfile(savePath, sprintf("%s_location_of_features.png", name)))

