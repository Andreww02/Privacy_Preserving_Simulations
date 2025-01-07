clear
clc
close all

img = imread('cameraman.tif');
img = img(:,1:round(end));
img=double(img);

colormap gray
imagesc(img)
axis image


rng(1)
[xToSample, yToSample] = generateCircleSamplesPts(size(img), 4, [10,50], 100);

hold on 
tmp = axis;
for row = 1:size(xToSample,1)
    ATplot(xToSample(row,:),yToSample(row,:))
end
axis(tmp)
axis off

% test feat extraction
% [features, metrics] = maxMinFeaturesAlongCurves(img, xToSample,yToSample);
interpVals = interp2(img,xToSample,yToSample);
figure
xvals = linspace(0,2*pi, size(interpVals,2));
ATplot(xvals,interpVals')
hold on
[a,bmax] = max(interpVals,[],2);
ATplot(xvals(bmax),a,'go');
[a,bmin] = min(interpVals,[],2);
ATplot(xvals(bmin),a,'mo');

fp = getATfontParams();
xlabel('Position around circle [rad]',fp{:});
ylabel('Interpolated intensity',fp{:});
xlim tight
ATprettify();

figure(1)
hold on
for circI = 1:size(xToSample,1)
    ATplot(xToSample(circI,bmax(circI)), yToSample(circI,bmax(circI)),'gx')
    ATplot(xToSample(circI,bmin(circI)), yToSample(circI,bmin(circI)),'mx')
end

