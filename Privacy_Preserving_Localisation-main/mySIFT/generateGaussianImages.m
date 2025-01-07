function gaussianImgs = generateGaussianImages(img, nOct, gaussianSigmas)
    % generate a cell array of each octave contianing a stack of matricies
    % for each img

    gaussianImgs = {};

    for octIdx = 1:nOct
        gImgInOct = zeros(size(img,1), size(img,2), length(gaussianSigmas));
        
        gImgInOct(:,:,1) = img; % first image is already blurred as needed

        for gSigIdx = 2:length(gaussianSigmas)
            img = imgaussfilt(img, gaussianSigmas(gSigIdx));
            gImgInOct(:,:,gSigIdx) = img;
        end

        % store in octave stack
        gaussianImgs{octIdx} = gImgInOct;

        % half size to prep for next octave
        octaveBaseImg = gImgInOct(:, :, end-3);
        img = imresize(octaveBaseImg, 0.5, "bilinear");
    end

end