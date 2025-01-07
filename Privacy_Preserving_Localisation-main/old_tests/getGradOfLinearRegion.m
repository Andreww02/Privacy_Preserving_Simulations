function m = getGradOfLinearRegion(x,y,theshold)

    foundVec = find( abs(diff(y,2))<theshold);
    
    % now find longest string on numbers in foundVec
    i=reshape(find(diff([0,diff(foundVec)==1,0])~=0),2,[]);
    [lgtmax,jmax]=max(diff(i));
    istart=i(1,jmax);
    
    if isempty(istart)
        m = nan;
    else
        ySubset = y(istart:istart + lgtmax);
        xSubset = x(istart:istart + lgtmax);

        m = (ySubset(end) - ySubset(1))/(xSubset(end) - xSubset(1));
    end
end