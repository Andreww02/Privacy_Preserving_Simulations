clear
clc
close all

img = imread("../data/MyDsets/stills/illumChange/DJI_20220422_112824_23.jpg");
img = im2gray(img);
img = im2double(img);

% img = [zeros(10,10), ones(10,10)];

% P = peaks(20);
% img = repmat(P,[5 10]);


figure
imagesc(img)

Y = fftshift(fft2(img));
figure
imagesc(log(abs(Y)))


% verticalLine = zeros(size(img));

verticalLine(:,2) = 1;
verticalLine(:,[1 2 4 5]) = 0;
figure
imagesc(verticalLine)
Yline = fftshift(fft2(verticalLine));
figure
imagesc(log(abs(Yline)))

newImg = ifft2(ifftshift(Y.*Yline));
figure
imagesc(newImg)
