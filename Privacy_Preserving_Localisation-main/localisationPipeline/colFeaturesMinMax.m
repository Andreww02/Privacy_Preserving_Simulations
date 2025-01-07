function [feat,metric] = colFeaturesMinMax(img, useMetric, useNormalise)
    % compute max and min of each column
    feat = [max(double(img))', min(double(img))'];

    if useMetric
        metric = max(double(img))'-min(double(img))';
    else
        metric = ones(size(img,2),1);
    end


    if useNormalise
        feat = feat./mean(img(:));
        if useMetric
            metric = metric./mean(img(:));
        end
    end
end