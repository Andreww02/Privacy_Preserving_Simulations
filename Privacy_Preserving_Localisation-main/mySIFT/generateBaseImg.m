function baseImg = generateBaseImg(img, sigma, assumedBlur)
    sizeFactor = 2;

    largerImg = imresize(img, sizeFactor, "bilinear");

    additionalSigma = sqrt(max([(sigma^2) - ((sizeFactor * assumedBlur)^2), 0.01]));

    baseImg = imgaussfilt(largerImg, additionalSigma);
end