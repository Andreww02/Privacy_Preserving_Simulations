function [feat,metric] = minMaxColFeaturesNoMetric(img)
    % compute max and min of each column
    feat = [max(double(img))', min(double(img))'];
    metric = ones(size(img,2),1);
end