function ds = loadImgs(ds)
    j = 1;
    for imgIdx = ds.imageIndices
        if ds.isPadded
        filename = sprintf('%s/%s%06d%s%s', ds.imagePath, ...
            ds.prefix, ...
            imgIdx, ...
            ds.suffix, ...
            ds.extension);
        else
        filename = sprintf('%s/%s%d%s%s', ds.imagePath, ...
            ds.prefix, ...
            imgIdx, ...
            ds.suffix, ...
            ds.extension);
        end
        
        img = imread(filename);
        
        if ds.convert2gray
            % check that operation is valid
            if imgIdx == ds.imageIndices(1)
                assert(length(size(img)) == 3)
            end
            grayImg = im2gray(img);
        end
        
        grayImg = double(grayImg);
        
        ds.imgs{j} = grayImg;
        j = j + 1;
    end

end
