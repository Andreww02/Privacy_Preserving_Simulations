function [features, metrics] = featureSPC(img)

    img = double(img);
    features = [mean(img(:)), 0*std(img(:))];
    metrics = [1];


end