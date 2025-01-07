function [xToSample, yToSample, tSamples] = lines2SamplePoints(lines, nSamples)
    xToSample = zeros(length(lines), nSamples);
    yToSample = zeros(length(lines), nSamples);

    for lineIdx = 1:length(lines)
        line = lines(lineIdx);
        tSamples = linspace(line.tBound(1),line.tBound(2),nSamples);
    
        res = repmat(line.point,1, nSamples) + tSamples.*line.dir;
        xToSample(lineIdx,:) = res(1,:);
        yToSample(lineIdx,:) = res(2,:);
    end


end