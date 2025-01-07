function img = ATreadimage(dset, imgIdx)
    % alternative interface to make sure all images are standardised as
    % part of a dataset

    
    img = readimage(dset.imageSet, imgIdx);
    img = im2double(img);

    % adjust for brightness factor now
    img = dset.brightnessFact*img;
    img(img > 1) = 1;

end