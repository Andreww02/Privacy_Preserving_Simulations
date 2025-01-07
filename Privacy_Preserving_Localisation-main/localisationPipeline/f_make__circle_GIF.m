clear
clc
close all

img = imread('cameraman.tif');
img = img(:,1:round(end));
img=double(img);


nSamples = 100;
rng(30)
[xToSample, yToSample] = generateCircleSamplesPts(size(img), 1, [10,50], nSamples);

interpVals = interp2(img,xToSample,yToSample);
xvals = linspace(0,2*pi, size(interpVals,2));

im_to_gif = {};


figure
set(gcf,'Position', 1.0e+03 *[0.0946    0.2166    1.3068    0.4248])


for sampleIdx = 2:nSamples
% for sampleIdx = 99:nSamples

    subaxisOpts = {'mb',0.15};
    subaxis(1,3,1, subaxisOpts{:})
    
    colormap gray
    imagesc(img)
    axis image
    
    hold on
    tmp = axis;
    for row = 1:size(xToSample,1)
        ATplot(xToSample(row,1:sampleIdx),yToSample(row,1:sampleIdx),'b','forceLinear',true)
    end
    axis(tmp)
    set(gca, 'xtick',[], 'ytick',[])
    % axis off
    
    subaxis(1,3,2, subaxisOpts{:})
    % illuminate a small patch around the image
    [xx,yy] = meshgrid(1:size(img,1));
    
    
    colormap gray
    mask = exp(-((xx-xToSample(1,sampleIdx)).^2 + (yy-yToSample(1,sampleIdx)).^2)/50);
    imagesc(img.*mask,[0,255]);
    axis image
    hold on
    plot(xToSample(1,sampleIdx), yToSample(1,sampleIdx),'wo', MarkerSize=20)
    % axis off
    set(gca, 'xtick',[], 'ytick',[])
    
    subaxis(1,3,3, subaxisOpts{:})
    ATplot(xvals(1:sampleIdx),interpVals(1:sampleIdx)','b')
    xlim([0,2*pi])
    ylim([0,255])
    fp = getATfontParams();
    xlabel('Position around circle [rad]',fp{:});
    ylabel('Interpolated intensity',fp{:});
    ATprettify('useAllAx',false,'figParams',{},'plotParams',{});
    grid on
    plot_darkmode
    set(gcf,'color','k')

    [frame, alpha] = export_fig;
    im_to_gif{sampleIdx} = frame;
%     im_to_gif{sampleIdx} = frame2im(frame);

%     gif
%     exportgraphics(gcf,fullfile('..','results','circ_animated.gif'),'Append',true);
end

hold on
[a,bmax] = max(interpVals,[],2);
ATplot(xvals(bmax),a,'go');
[a,bmin] = min(interpVals,[],2);
ATplot(xvals(bmin),a,'mo');

subaxis(1,3,1, subaxisOpts{:})
ATplot(xToSample(1,bmax(1)), yToSample(1,bmax(1)),'gx')
ATplot(xToSample(1,bmin(1)), yToSample(1,bmin(1)),'mx')

[frame, alpha] = export_fig;
im_to_gif{sampleIdx} = frame;

%%
filename = "testAnimated.gif"; % Specify the output file name
for idx = 2:length(im_to_gif)
    [A,map] = rgb2ind(im_to_gif{idx},256);
    if idx == 2
        imwrite(A,map,filename,"gif","LoopCount",0,"DelayTime",6);
    elseif idx == length(im_to_gif)
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",30);
    else
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.2);
    end
end