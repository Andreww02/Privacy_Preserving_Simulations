function mask = getValidHardwareMask(maskName, opt)
    % restrict fspecial to only use non negative values for valid hardware
    % implementations
    if strcmp(maskName, "disk")
        mask = fspecial('disk',opt.radius);
        
        if opt.isInverse
            mask = max(mask(:)) - mask;
            mask = mask/sum(mask(:));
        end
        
    elseif strcmp(maskName, "gaussian")
        mask = fspecial('gaussian',opt.hsize,opt.sigma);
        
    elseif strcmp(maskName, "average")
        mask = fspecial('average',opt.hsize);
        
    elseif strcmp(maskName, "edge")
        mask = zeros(opt.hsize);
        
        % opt.edgeStrength>1 is the ratio of the two halves of the filter
        
        % make horiz by default
        % check if middle row is going to be middle
        if mod(size(mask,1),2) == 0
            mask(:,1:size(mask,1)/2) = opt.edgeStrength;
            mask(:,size(mask,1)/2 + 1:end) = 1;
        else
            mask(:,1:(size(mask,1)-1)/2) = opt.edgeStrength;
            mask(:,(size(mask,1)+1)/2 + 1:end) = 1;
            mask(:,(size(mask,1)+1)/2) = mean([opt.edgeStrength,1]);
        end
        
        if opt.isVertical == false
            mask = mask';
        end
        
        mask = mask./sum(mask(:));
    end
end