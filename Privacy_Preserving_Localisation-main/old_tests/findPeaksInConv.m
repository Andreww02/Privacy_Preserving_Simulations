function [pks,locs,w,p] = findPeaksInConv(conv,thresh)
    % calls findpeaks on each interesting pixel in conv stack, 
    
    if nargin == 1
        thresh = 40;
    end
    
    pks = zeros(size(conv,1),size(conv,2));
    locs = zeros(size(conv,1),size(conv,2));
    w = zeros(size(conv,1),size(conv,2));
    p = zeros(size(conv,1),size(conv,2));
    
    traceDiff = max(conv,[],3) - min(conv,[],3);
    for i = 1:size(traceDiff,1)
        for j = 1:size(traceDiff,2)
            if traceDiff(i,j) > thresh
                [pks(i,j), locs(i,j), w(i,j), p(i,j)] = getProminentPeak(reshape(conv(i,j,:),1,[]));
            else
                pks(i,j) = 0;
                locs(i,j) = 0;
                w(i,j) = 0;
                p(i,j) = 0;
            end
        end
    end
    
end