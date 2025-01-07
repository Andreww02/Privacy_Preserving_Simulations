function sig = generateGaussianSigmas(sigma, nIntervals)
    nImgPerOct = nIntervals + 3;
    k = 2^(1/nIntervals);
    sig = zeros(1,nImgPerOct);
    sig(1) = sigma;

    % find the difference in sigmas needed per image
    for i = 2:length(sig)
        % sigma of the previous image
        sigPrev = (k^(i-2)) * sigma;

        % sigma at current image
        sigTotal = k*sigPrev;

        % increment needed to keep constant k in scale space
        sig(i) = sqrt(sigTotal^2 - sigPrev^2);
    end
end