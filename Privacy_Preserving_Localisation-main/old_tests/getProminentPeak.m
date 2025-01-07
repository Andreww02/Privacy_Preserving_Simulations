function [pks,locs,w,p] = getProminentPeak(data)
    [pks,locs,w,p] = findpeaks(data,'SortStr','descend');
    if isempty(pks)
        pks = 0;
        locs = 0;
        w = 0;
        p = 0;
    else
        pks = pks(1);
        locs = locs(1);
        w = w(1);
        p = p(1);
    end
end