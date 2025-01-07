% compare the histogram of all pixels vs those in the hash


clear
clc
close all

% img = imread(fullfile('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb/00036.png'));
img = imread(fullfile('C:\Users\Andrew\Desktop\Thesis\ThesisData\ABS\norm\imgs\00078.png'));
% img = imread(fullfile('../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb/00768.png'));
orig_img = img;

figure
colormap gray
imshow(img)

img = double(img);


% use_lines = 1;
% use_circ = 0;

use_lines = 0;
use_circ = 1;

assert(~(use_lines && use_circ) && (use_lines || use_circ))

n_features = 1000;

rng(3)
if use_lines
    lines = generateRandomLines(size(img), n_features);
elseif use_circ
    [xToSample, yToSample] = generateCircleSamplesPts(size(img), n_features, [15,50], 100);
end

figure
histogram(reshape(img, 1,[]))
xlabel('Pixel intensity')
ylabel('Count')

if use_lines
    n_interp_points = 100;
    t = zeros(length(lines), n_interp_points);
    y = zeros(length(lines), n_interp_points);
    for i = 1:length(lines)
        [ta,ya] = drawTrace(img, lines(i), false);
        t(i,:) = ta;
        y(i,:) = ya;
    end
    figure
    histogram(max(y, [],2), FaceColor='b')
    hold on
    histogram(min(y, [],2), FaceColor='m')
elseif use_circ
    interpVals = interp2(img,xToSample,yToSample);
    [bmax,] = max(interpVals,[],2);
    [bmin,] = min(interpVals,[],2);
    
    figure
    histogram(bmax, FaceColor='b')
    hold on
    histogram(bmin, FaceColor='m')
    
end

xlabel('Feature value')
ylabel('Count')

%% saving
savePath = fullfile('../results/location_and_distribution_of_info');

if use_circ
    name = 'circ';
elseif use_lines
    name = 'line';
end

imwrite(orig_img, fullfile(savePath,sprintf("scene.png")))

figure(2)
ATprettify
save2pdf(gcf, fullfile(savePath,sprintf("image_dist.pdf")))


figure(3)
ATprettify
save2pdf(gcf, fullfile(savePath,sprintf("%s_dist.pdf", name)))




