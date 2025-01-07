clear
clc
close all




r = @(xx,yy) sqrt(xx.^2 + yy.^2);

plt_dist(@(xx,yy) normpdf(r(xx,yy)), 3)
saveas(gcf, 'gaussian.svg')


rng(2)
% centers = [0.1,2;
%            4,2;
%            0,0;
%            5, -4];
width = 5;
n_modes = 4;
centers = -width + 2*width*rand([n_modes, 2]);

amp = [0.5,2,3,2];
sig = [0.5,2,3,2];

assert(length(amp) == size(centers,1))

fn = @(xx,yy) 0;

for dist_idx = 1:length(amp)
    fn = @(xx,yy) fn(xx,yy) + amp(dist_idx)*normpdf(r(xx - centers(dist_idx,1),yy - centers(dist_idx,2)), sig(dist_idx));
end


plt_dist(fn, width)
saveas(gcf, 'multimode.svg')


rng(5)
width = 10;
x = linspace(-width,width);
n_modes = 4;
centres = -width + 2*width*rand([1, n_modes]);
amp = rand([1, n_modes])*10;
sig = rand([1, n_modes])*10;

fn = @(x) 0;

for dist_idx = 1:length(amp)
    fn = @(x) fn(x) + amp(dist_idx)*normpdf(x-centres(dist_idx),0, sig(dist_idx));
end

figure
ATplot(x, fn(x));
axis off 
ATprettify
saveas(gcf, 'hash_space.svg')

