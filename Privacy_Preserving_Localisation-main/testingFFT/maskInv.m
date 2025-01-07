clear;
clc;
close all;


N = 32;

M = zeros(N,N);

M(N/2-1:N/2+2,N/2-1:N/2+2) = 1;


imagesc(M)

Y = ifft2(M);

figure
imagesc(abs(ifftshift(Y)))

I = imread('cameraman.tif');

figure
imagesc(I);

figure
filtered = conv2(I,abs(ifftshift(Y)),'same');
imagesc(filtered);




