function [tvals,interpVals] = drawTrace(img, line, plot)
    arguments
        img 
        line
        plot = true
    end 


    [xToSample, yToSample, tvals] = lines2SamplePoints(line, 100);

    interpVals = interp2(img,xToSample,yToSample);
    if plot
        ATplot(tvals,interpVals)
    end

end