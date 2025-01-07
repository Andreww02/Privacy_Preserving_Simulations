clear;
clc;
close all;


h = fspecial("sobel");

Y = fft2(h);
imagesc(abs(fftshift(Y)))
