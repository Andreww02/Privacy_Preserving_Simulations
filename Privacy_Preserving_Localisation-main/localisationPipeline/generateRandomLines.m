function lines = generateRandomLines(imgSize, Nlines)
    % generates random lines along an image
    % return format is [point x, point y, dir x, dir y, tmin, tmax]
    % indicating a line spanned as [point] + dir*t, t in [tmin,tmax] such
    % that it fits in image

    lines = struct('point',{},'dir',{},'tBound',{});
    
    axesDir = [1 0;
                      1 0;
                      0 1;
                      0 1]';
    axesPts = [1,1;
                      1, imgSize(1);
                      1, 1;
                      imgSize(2), 1]'; % ones used for axes intercepts since this is the edge of the image


    for lineIdx = 1:Nlines
        lines(lineIdx).point = [1+(imgSize(2)-1)*rand(), 1+(imgSize(1)-1)*rand()]'; % have to flip bc axes different to image axes
        angle = 2*pi*rand();
        lines(lineIdx).dir = [cos(angle), sin(angle)]';

        % solve linear system to get bounds on t by finding all intercepts
        % with image bounds
        tVals = zeros(4,1);
        for i = 1:4
            st = inv([axesDir(:,i), -lines(lineIdx).dir])*(lines(lineIdx).point - axesPts(:,i));
            tVals(i) = st(2);
        end
        lines(lineIdx).tBound = [max(tVals(tVals<0)), min(tVals(tVals>0))];

    end

end