clear;
clc;
close all;

dset = '../../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';

imds = ATimds(dset, 1);

subImds = subset(imds,[1 2]);

img = readimage(imds, 2);

bag = bagOfFeatures(subImds.imds);