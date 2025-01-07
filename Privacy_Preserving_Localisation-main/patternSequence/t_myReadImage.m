clear
clc
close all

% dsetName = '../data/Digiteo_seq_2/Passive-Stereo/RGB-D/rgb';

dsetName = '../data/dum_cloudy1/png';


for brightnessFact = linspace(0.6,1.4,5)
    dset = getDset(dsetName,'brightnessFact',brightnessFact);
end



